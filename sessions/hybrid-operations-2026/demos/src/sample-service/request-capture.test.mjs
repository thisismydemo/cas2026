import test from 'node:test';
import assert from 'node:assert/strict';
import {execFile} from 'node:child_process';
import {promisify} from 'node:util';
import {mkdtemp,readFile,rm} from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import {createService} from './server.mjs';
const run=promisify(execFile);
const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'../../../../..');
test('PowerShell captures complete healthy, failed and recovered records for ingestion',async()=>{
 const prefix=path.join(os.tmpdir(),'cas26-capture-');
 const dir=await mkdtemp(prefix),statePath=path.join(dir,'state.json'),capture=path.join(dir,'capture.jsonl');
 const service=createService({statePath,logPath:path.join(dir,'server.jsonl')});
 await new Promise(resolve=>service.listen(0,'127.0.0.1',resolve));
 const base='http://127.0.0.1:'+service.address().port;
 const ps=(script,args)=>run('pwsh',['-NoProfile','-File',path.join(root,script),...args],{cwd:root});
 try{
  for(const mode of ['Healthy','Fail','Healthy']){
   await ps('sessions/hybrid-operations-2026/demos/scripts/Set-Cas26WorkerMode.ps1',['-Mode',mode,'-StatePath',statePath]);
   await ps('sessions/hybrid-operations-2026/demos/scripts/Invoke-Cas26Request.ps1',['-BaseUri',base,'-Count','3','-IntervalSeconds','0','-JsonLinesPath',capture]);
   assert.equal((await fetch(base+'/healthz')).status,200);
  }
  const rows=(await readFile(capture,'utf8')).trim().split('\n').map(JSON.parse);
  assert.deepEqual(rows.map(r=>r.Success),[true,true,true,false,false,false,true,true,true]);
  assert.equal(new Set(rows.map(r=>r.RequestId)).size,9);
  for(const row of rows){assert.equal(row.Service,'cas26-requests');assert.ok(row.Computer);assert.ok(Number.isFinite(Date.parse(row.TimeGenerated)));}
  const sent=await ps('sessions/azure-monitor-hybrid-multicloud-observability/demos/scripts/Send-Cas26Telemetry.ps1',['-Endpoint','https://cas26-test.ingest.monitor.azure.com','-ImmutableId','dcr-test123','-JsonLinesPath',capture,'-WhatIf']);
  assert.match(sent.stdout,/Send 9 CAS26 telemetry rows/);
 }finally{
  await new Promise(resolve=>service.close(resolve));
  const resolved=path.resolve(dir);
  assert.ok(resolved.startsWith(path.resolve(prefix)),'Cleanup must remain in the generated test directory');
  await rm(resolved,{recursive:true,force:true});
 }
});
