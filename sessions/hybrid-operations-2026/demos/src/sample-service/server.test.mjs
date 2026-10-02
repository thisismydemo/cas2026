import test from 'node:test';import assert from 'node:assert/strict';import {mkdtemp,writeFile,readFile,rm} from 'node:fs/promises';import os from 'node:os';import path from 'node:path';import {createService} from './server.mjs';
test('request success, controlled failure, recovery and liveness remain distinct',async()=>{
 const dir=await mkdtemp(path.join(os.tmpdir(),'cas26-service-'));const statePath=path.join(dir,'state.json');const logPath=path.join(dir,'events.jsonl');
 const server=createService({statePath,logPath});await new Promise(resolve=>server.listen(0,'127.0.0.1',resolve));
 try{const url='http://127.0.0.1:'+server.address().port;
 let response=await fetch(url+'/request');assert.equal(response.status,200);assert.equal((await response.json()).Success,true);
 await writeFile(statePath,JSON.stringify({project:'cas26',mode:'Fail'}));response=await fetch(url+'/request');assert.equal(response.status,503);assert.equal((await response.json()).Success,false);
 assert.equal((await fetch(url+'/healthz')).status,200);
 await writeFile(statePath,JSON.stringify({project:'cas26',mode:'Healthy'}));response=await fetch(url+'/request');assert.equal(response.status,200);
 assert.equal((await fetch(url+'/other')).status,404);
 assert.equal((await fetch(url+'/request',{method:'POST'})).status,405);
 const rows=(await readFile(logPath,'utf8')).trim().split('\n').map(JSON.parse);assert.deepEqual(rows.map(r=>r.Success),[true,false,true]);assert.equal(new Set(rows.map(r=>r.RequestId)).size,3);
 }finally{await new Promise(resolve=>server.close(resolve));await rm(dir,{recursive:true,force:true});}
});
test('invalid state fails closed without exposing local details',async()=>{
 const dir=await mkdtemp(path.join(os.tmpdir(),'cas26-service-'));const statePath=path.join(dir,'state.json');await writeFile(statePath,'not-json');
 const server=createService({statePath,logPath:path.join(dir,'events.jsonl')});await new Promise(resolve=>server.listen(0,'127.0.0.1',resolve));
 try{const response=await fetch('http://127.0.0.1:'+server.address().port+'/request');assert.equal(response.status,503);assert.equal((await response.json()).Message,'Worker unavailable or state invalid');}
 finally{await new Promise(resolve=>server.close(resolve));await rm(dir,{recursive:true,force:true});}
});

test('split endpoint propagates correlation and worker failure',async()=>{
 const dir=await mkdtemp(path.join(os.tmpdir(),'cas26-split-'));const statePath=path.join(dir,'state.json');
 const worker=createService({statePath,logPath:path.join(dir,'worker.jsonl')});await new Promise(resolve=>worker.listen(0,'127.0.0.1',resolve));
 const endpoint=createService({workerUrl:'http://127.0.0.1:'+worker.address().port,logPath:path.join(dir,'endpoint.jsonl')});await new Promise(resolve=>endpoint.listen(0,'127.0.0.1',resolve));
 try { const url='http://127.0.0.1:'+endpoint.address().port+'/request';let response=await fetch(url);assert.equal(response.status,200);const first=await response.json();
 const workerRow=JSON.parse((await readFile(path.join(dir,'worker.jsonl'),'utf8')).trim());assert.equal(first.RequestId,workerRow.RequestId);
 await writeFile(statePath,JSON.stringify({project:'cas26',mode:'Fail'}));response=await fetch(url);assert.equal(response.status,503);
 } finally {await new Promise(resolve=>endpoint.close(resolve));await new Promise(resolve=>worker.close(resolve));await rm(dir,{recursive:true,force:true});}
});
