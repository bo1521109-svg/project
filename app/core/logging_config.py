import logging
import sys
from pathlib import Path


def setup_logging():
    """
    配置日志系统
    
    - 日志格式：包含时间、级别、模块名、消息
    - 输出：同时输出到控制台（Console）和文件（logs/crawler.log）
    """
    # 创建 logs 目录
    log_dir = Path("/app/logs")
    log_dir.mkdir(exist_ok=True)
    
    # 日志格式
    log_format = "%(asctime)s - %(levelname)s - %(name)s - %(message)s"
    date_format = "%Y-%m-%d %H:%M:%S"
    
    # 获取日志级别
    import os
    log_level = os.getenv("LOG_LEVEL", "INFO")
    
    # 配置根日志记录器
    logging.basicConfig(
        level=getattr(logging, log_level),
        format=log_format,
        datefmt=date_format,
        handlers=[
            # 控制台输出（Docker 环境仅输出到控制台，避免文件描述符耗尽）
            logging.StreamHandler(sys.stdout),
        ]
    )
    
    # 获取爬虫日志记录器
    logger = logging.getLogger("crawler")
    logger.setLevel(getattr(logging, log_level))
    
    return logger


# 创建全局日志记录器
logger = setup_logging()
