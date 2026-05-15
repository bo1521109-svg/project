#!/bin/bash
# 数据库迁移执行脚本
# 用法: 
#   ./run_migrations.sh          # 执行所有迁移
#   ./run_migrations.sh 001      # 执行指定迁移
#   ./run_migrations.sh preview 004  # 预览模式
#   ./run_migrations.sh downgrade 002  # 回滚指定迁移

set -e

echo "=========================================="
echo "数据库迁移工具"
echo "=========================================="

# 进入容器执行迁移
CONTAINER_NAME="fastapi_app"

# 检查容器是否运行
if ! docker ps | grep -q $CONTAINER_NAME; then
    echo "错误: 容器 $CONTAINER_NAME 未运行"
    echo "请先启动容器: docker compose up -d"
    exit 1
fi

# 执行迁移
if [ "$1" == "preview" ]; then
    # 预览模式
    MIGRATION_NUM=${2:-"004"}
    echo "预览迁移: $MIGRATION_NUM"
    SCRIPT="/app/scripts/migrations/${MIGRATION_NUM}_*.py"
    docker exec $CONTAINER_NAME bash -c "python $SCRIPT preview"
    
elif [ "$1" == "downgrade" ]; then
    # 回滚迁移
    MIGRATION_NUM=${2:-"all"}
    echo "回滚迁移: $MIGRATION_NUM"
    
    if [ "$MIGRATION_NUM" == "all" ]; then
        # 回滚所有迁移（倒序）
        for script in $(ls -r /app/scripts/migrations/*.py 2>/dev/null); do
            echo "执行回滚: $script"
            docker exec $CONTAINER_NAME python $script downgrade
        done
    else
        # 回滚指定迁移
        SCRIPT="/app/scripts/migrations/${MIGRATION_NUM}_*.py"
        echo "执行回滚: $SCRIPT"
        docker exec $CONTAINER_NAME bash -c "python $SCRIPT downgrade"
    fi
else
    # 执行迁移
    MIGRATION_NUM=${1:-"all"}
    echo "执行迁移: $MIGRATION_NUM"
    
    if [ "$MIGRATION_NUM" == "all" ]; then
        # 执行所有迁移（顺序）
        docker exec $CONTAINER_NAME bash -c "
            for script in /app/scripts/migrations/*.py; do
                echo '执行迁移: \$script'
                python \$script
            done
        "
    else
        # 执行指定迁移
        SCRIPT="/app/scripts/migrations/${MIGRATION_NUM}_*.py"
        echo "执行迁移: $SCRIPT"
        docker exec $CONTAINER_NAME bash -c "python $SCRIPT"
    fi
fi

echo ""
echo "=========================================="
echo "操作完成！"
echo "=========================================="
