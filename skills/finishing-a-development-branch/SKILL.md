---
name: finishing-a-development-branch
description: 所有任务完成、闭环已走后激活。验证测试、展示选项（合并/PR/保留/丢弃）、清理工作树。触发 closing-the-loop。柔性技能。
---

# Finishing a Development Branch：分支收尾

## 技能类型：柔性

---

## 何时使用

- 所有实施任务已完成
- closing-the-loop 已执行
- 代码已推送

---

## 工作流

```
1. 确认所有测试通过
   → 跑完整测试套件（不只是你改的那部分）

2. 确认 closing-the-loop 已完成
   → 如果没有 → 先执行 closing-the-loop 技能

3. 展示选项
   ├─ 合并到 main/master（直接合并或 PR）
   ├─ 保留分支（仍有后续工作）
   └─ 丢弃分支（实验性工作，不需要合并）

4. 清理
   → 如果使用了 git worktree → 清理工作树
   → 删除已合并的本地分支
```

---

## AgentProgramming 增强：确保闭环

在收尾之前，强制检查：

- [ ] closing-the-loop 的钢印 5 项全部通过？
- [ ] L3 experience.md 已更新？
- [ ] Roadmap 已追加？
- [ ] 知识库已推送？

如果上述任一项未完成 → **停止收尾，先执行 closing-the-loop**。

---

## Red Flags

| 你的想法 | 真相 |
|---------|------|
| "直接合并吧，反正测试过了" | closing-the-loop 做了吗？没做 = 经验丢了。 |
| "这个小分支不需要记录" | 所有代码变更都要记入 roadmap。 |
