import http from 'node:http';
import {readFile,appendFile,mkdir} from 'node:fs/promises';
import path from 'node:path';
import {randomUUID} from 'node:crypto';
import {hostname} from 'node:os';
import {pathToFileURL} from 'node:url';
export async function workerMode(statePath){
 try{const state=JSON.parse(await readFile(statePath,'utf8'));if(state.project!=='cas26'||!['Healthy','Fail'].includes(state.mode))throw new Error('Invalid CAS26 state');return state.mode;}
 catch(error){if(error.code==='ENOENT')return 'Healthy';throw error;}
}
export function createService({statePath,logPath,workerUrl}){
 return http.createServer(async(req,res)=>{
  res.setHeader('Content-Type','application/json');res.setHeader('Cache-Control','no-store');
  if(req.method!=='GET'){res.writeHead(405);res.end(JSON.stringify({error:'Only GET is supported'}));return;}
  if(req.url==='/healthz'){res.end(JSON.stringify({process:'running',project:'cas26',note:'Process liveness only; use /request to test service outcome.'}));return;}
  if(req.url!=='/request'){res.writeHead(404);res.end(JSON.stringify({error:'Use /request or /healthz'}));return;}
  const start=performance.now();const incomingId=req.headers['x-cas26-request-id'];
  const requestId=typeof incomingId==='string'&&/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(incomingId)?incomingId:randomUUID();let success=false;let message='';
  try{
   if(workerUrl){const upstream=await fetch(new URL('/request',workerUrl),{signal:AbortSignal.timeout(5000),headers:{'x-cas26-request-id':requestId}});const body=await upstream.json();success=upstream.ok&&body.Success===true;message=success?'Worker completed request':'Worker failed request';}
   else{success=(await workerMode(statePath))==='Healthy';message=success?'Worker completed request':'Controlled CAS26 worker failure';}
  }catch{message='Worker unavailable or state invalid';}
  const row={TimeGenerated:new Date().toISOString(),Service:'cas26-requests',Computer:hostname(),RequestId:requestId,Success:success,DurationMs:Math.round(performance.now()-start),Message:message};
  try{await mkdir(path.dirname(logPath),{recursive:true});await appendFile(logPath,JSON.stringify(row)+'\n');}
  catch{res.writeHead(500);res.end(JSON.stringify({error:'Telemetry persistence failed',RequestId:requestId}));return;}
  res.writeHead(success?200:503);res.end(JSON.stringify(row));
 });
}
if(process.argv[1]&&import.meta.url===pathToFileURL(path.resolve(process.argv[1])).href){
 const port=Number(process.env.CAS26_PORT||4310);
 const statePath=path.resolve(process.env.CAS26_WORKER_STATE||'.artifacts/cas26/worker-state.json');
 const logPath=path.resolve(process.env.CAS26_LOG_PATH||'.artifacts/cas26/service.jsonl');
 const host=process.env.CAS26_BIND||'127.0.0.1';
 const server=createService({statePath,logPath,workerUrl:process.env.CAS26_WORKER_URL});
 server.listen(port,host,()=>console.log('CAS26 local sample service: http://'+host+':'+port+'/request'));
 server.on('error',error=>{console.error(error.message);process.exitCode=1;});
 for(const signal of ['SIGINT','SIGTERM'])process.on(signal,()=>server.close());
}
