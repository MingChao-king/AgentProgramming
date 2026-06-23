---
name: hotfix
description: 用户显式调用 skill:hotfix 时激活。紧急修复精简通道：mini brainstorming → fix → test → closing-the-loop(mini)。柔性技能。
---

# Hotfix：紧急修复精简通道

## 技能类型：柔性

仅当用户显式调用 `skill:hotfix` 时触发。不自动检测。

---

## 何时使用

- 用户明确说 "hotfix" / "紧急修复" / "skill:hotfix"
- P0 生产故障需要快速修复
- 配置热修复、数据修复等紧急操作

**不是紧急场景 → 走标准工作流（brainstorming → writing-plans → implementing → closing-the-loop）。**

---

## 精简流程

```
skill:hotfix 触发
       │
       ▼
Mini Brainstorming（5 分钟）
  → 澄清 bug 现象和影响范围
  → 定位涉及的类/方法（git log 最近变更）
  → 修复思路（1-3 句话）
  → 记录于 roadmap §5
       │
       ▼
TDD 修复
  → RED：写复现测试，确认 bug 存在
  → GREEN：最小修复，测试变绿
  → REFACTOR：同类 bug 搜索（Grep 相同模式），一并修复
       │
       ▼
快速审查 + 测试
  → Subagent 审查（8 维，重点：回归风险 + 正确性）
  → 子功能全量测试（4 类场景）
       │
       ▼
Closing the Loop（mini）
  → git commit（本地）
  → roadmap §5 追加
  → 如有新技术知识 → L2 提炼
```

---

## 与标准工作流的区别

| 环节 | 标准工作流 | hotfix |
|------|-----------|--------|
| brainstorming | 完整 4 步 | mini（只澄清 bug + 定位代码） |
| writing-plans | 功能拆分 + 防重复 | 跳过 |
| implementing | 逐功能完整循环 | 只修 bug + 同类搜索 |
| code review | 8 维全量 | 8 维，重点关注回归+正确性 |
| 子功能测试 | 4 类并行 | 4 类并行 |
| 集成测试 | 全场景 | 跳过 |
| closing-the-loop | 完整 5 项 | mini（3 项） |

---

## Red Flags

| 你的想法 | 真相 |
|---------|------|
| "这个 bug 很急，跳过测试直接修" | 紧急修复才最需要测试——修错了一分钟变一小时。 |
| "hotfix 不要写复现测试，直接改" | 不先复现 = 你不知道根因 = 可能修错地方。 |

---

## 完成标准

- [ ] Mini brainstorming 已完成（bug 现象 + 涉及代码 + 修复思路已记录 roadmap）
- [ ] 复现测试通过（确认 bug 存在）
- [ ] 修复后测试全绿
- [ ] Subagent 审查通过（P0=0, P1=0）
- [ ] 同类 bug 搜索完成
- [ ] Git commit（本地）
- [ ] Roadmap §5 已追加
- [ ] Closing-the-loop(mini) 完成
