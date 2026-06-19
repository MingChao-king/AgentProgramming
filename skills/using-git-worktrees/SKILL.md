---
name: using-git-worktrees
description: 需要并行开发分支时激活。创建隔离的 git 工作树，在新分支上工作，不影响主分支。柔性技能。
---

# Using Git Worktrees：Git 工作树隔离

## 技能类型：柔性

---

## 何时使用

- 需要同时在一个以上的分支上工作
- 需要在隔离的环境中测试某个分支
- 当前分支有未提交的更改，但需要紧急处理另一个问题

---

## 工作流

```
1. 创建工作树
   git worktree add -b feature/xxx ../project-xxx main

2. 在新工作树中工作
   cd ../project-xxx
   # 安装依赖，运行测试基线

3. 工作完成后
   git push origin feature/xxx
   # 回到原工作目录

4. 清理
   git worktree remove ../project-xxx
```

---

## AgentProgramming 增强

- 新工作树中同样要遵循 brainstorming → writing-plans → TDD → closing-the-loop
- 知识库是共享的，新工作树中的发现同样要回写
- 工作树清理前确保 L3/roadmap 已更新

---

## 关键行为准则

- 工作树名具有描述性（`feature/user-auth` 而非 `temp-branch`）
- 进入工作树后先跑测试基线，确认环境正常
- 离开工作树前提交或放弃所有更改
