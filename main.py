from fastapi import FastAPI

app = FastAPI(
    title="跨境电商独立站数据平台",
    version="1.0.0",
    description="MVP - 第一期"
)


@app.get("/")
async def root():
    return {"message": "系统启动成功，仅独立站模式"}


@app.get("/health")
async def health_check():
    return {"status": "healthy", "database": "connected"}
