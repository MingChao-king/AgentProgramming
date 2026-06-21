---
name: subagent-driven-development
description: 有 ≥2 个独立任务时强制激活。每个任务走 3-agent 流水线：implementer(TDD) → spec-reviewer → quality-reviewer，含 review loop（≤3 轮）。刚性技能。
---

<EXTREMELY-IMPORTANT>
此技能是刚性技能。≥2 个互不依赖的独立任务时，**必须**派发子代理并行执行。

3-agent 流水线不可跳过：implementer → spec-reviewer → quality-reviewer。缺少任一 reviewer = 未经审查的代码进入主分支。

如果你在想"我自己审一下就行" — 读 Red Flags。
</EXTREMELY-IMPORTANT>

# Subagent-Driven Development：3-Agent 流水线

## 技能类型：刚性

每个任务必须走完整流水线。串行执行独立任务 = 浪费时间和 token。

---

## 何时必须使用

以下条件**全部满足**时，必须派发子代理：

1. 任务清单中有 ≥2 个任务
2. 这些任务**互不依赖**（任务 A 的输出不是任务 B 的输入）
3. 每个任务在 writing-plans 中已有明确的文件路径和验证方式

---

## 3-Agent 流水线

```
每个任务独立执行以下流水线：

  ┌─────────────────────────────────────────────┐
  │ Agent 1: IMPLEMENTER（全工具）               │
  │   1. 防重复检查（搜索已有类似代码）            │
  │   2. TDD RED: 写测试 → 确认失败               │
  │   3. TDD GREEN: 最小实现 → 确认通过            │
  │   4. TDD REFACTOR: 清理 → 保持绿色             │
  │   5. 自审（对照任务描述逐项检查）              │
  │   6. git commit（RED/GREEN/REFACTOR 各一次）  │
  │   输出：实现概要 + 测试结果 + 自审结论          │
  ├─────────────────────────────────────────────┤
  │ Agent 2: SPEC-REVIEWER（只读）               │
  │   对照任务描述逐项审查：                       │
  │   → 是否实现了所有要求的文件？                 │
  │   → 是否多做了范围外的事（scope creep）？      │
  │   → 测试是否覆盖了 4 类场景？                  │
  │   → 验证步骤是否全部通过？                     │
  │   输出：通过 / 需修复（含具体问题列表）         │
  ├─────────────────────────────────────────────┤
  │ Agent 3: QUALITY-REVIEWER（只读）             │
  │   对照项目标准逐项审查：                       │
  │   → 是否遵循项目代码模式（CLAUDE.md § Patterns）？│
  │   → 是否有重复代码（DRY）？命名是否清晰？       │
  │   → 边界情况是否处理？错误处理是否完善？         │
  │   → 是否有安全漏洞（注入/越权/数据泄露）？      │
  │   输出：通过 / 需修复（含具体问题列表）         │
  └─────────────────────────────────────────────┘
```

---

## Review Loop 机制

任一 reviewer 不通过 → implementer 针对性修复 → 同一 reviewer 再审：

```
Reviewer 报告"需修复"（含 N 条问题）
    │
    ▼
Implementer 逐条修复（只修报告中的问题，不趁机重构）
    │
    ▼
同一 Reviewer 再审
    ├─ 通过 → 进入下一阶段
    └─ 仍不通过 → implementer 再次修复（≤3 轮）
        └─ 第 3 轮仍不通过 → STOP，报告主代理决策
```

**规则**：
- Spec-reviewer 通过后才进入 quality-reviewer（不跳跃）
- 每轮修复只修 reviewer 指出的问题（YAGNI）
- 3 轮不通过 → 主代理介入（任务描述可能有歧义，或 reviewer 标准过严）

---

## 5 段式 Prompt 模板

所有子代理使用统一结构：

```
SCOPE: [精确的文件路径列表]

GOAL: [可验证的目标 — "创建 XxxDTO，字段 A/B/C，@Data + @Builder"]

CONSTRAINTS:
  1. [来自 CLAUDE.md 的约束]
  2. [项目代码模式要求]
  3. [TDD 三元组要求（仅 implementer）]

DO NOT:
  - [禁止行为 1]
  - [禁止行为 2]

RETURN: [输出格式 — "实现概要 + 测试结果 + 自审结论"]
```

### Implementer 专用 CONSTRAINTS

```
CONSTRAINTS:
  1. 写之前搜索项目中是否已有类似代码（防重复）
  2. 不确定 API/方法签名时查 L4 源码（不凭记忆）
  3. 严格 TDD：RED(先写测试) → GREEN(最小实现) → REFACTOR(清理)
  4. 只写任务要求的最少代码（YAGNI）
  5. 发现计划外问题立即回报，不擅自扩大范围
  6. 测试覆盖 4 类场景：隔离/边界/并发/异常，每类 ≥2 条
```

### Reviewer 专用 DO NOT

```
DO NOT:
  - 不要修改代码（你是只读审查者）
  - 不要提出"更好但不在任务范围内"的建议
  - 不要通过模糊感觉判断 — 每条问题引用具体文件:行号
```

---

## 并行调度策略

互不依赖的任务用 `dispatching-parallel-agents` 技能同时派发。多个并行任务各自走独立流水线。

### 审查不通过处理

| 级别 | 不通过处理 |
|------|-----------|
| Spec 不合规 | Implementer 修复 → spec-reviewer 再审 |
| Quality 不合规 | Implementer 修复 → quality-reviewer 再审 |
| 3 轮不通过 | 主代理介入决策（修任务描述 / 放宽标准 / 手动修复） |

---

## Red Flags — 你在跳过审查

| 你的想法 | 真相 |
|---------|------|
| "我自己审一下就行，不用独立 reviewer" | 你写的代码你自己审有盲区。独立 reviewer 不带实现者的假设。 |
| "就两个任务，串行做了吧" | 2 个独立任务就值得并行。门槛是 2，不是 5。 |
| "reviewer 说有问题但我看了下觉得还行" | 不要否决 reviewer。reviewer 是独立判断，覆盖了你的盲区。 |
| "3 轮不通过太浪费时间，我直接修" | 3 轮不通过说明任务描述或 reviewer 标准有问题 —— 这正是需要主代理介入的信号。 |
| "子代理也需要上下文，不如我自己做" | 5 段式 prompt 已含所有上下文。子代理不加载主对话历史。 |
| "review loop 太慢了，快速过一下就行" | 跳过 review loop = 未经审查的代码。一小时 review < 一天 debug。 |

---

## 关键行为准则

- **子代理失败** → 分析原因，调整 prompt，重新派发
- **产出偏离计划** → spec-reviewer 会拦截，不用担心
- **不要强行拆分有依赖的任务** → 依赖任务必须串行
- **Reviewer 冲突** → 主代理判断，但默认信任 reviewer（reviewer 没盲区）
- **派发后主代理不闲着** → 处理有依赖的任务或准备下一阶段

---

## 完成标准

- [ ] 任务清单已按依赖关系分组（识别并行组）
- [ ] 每个任务已派发 implementer 子代理
- [ ] 每个 implementer 产出已通过 spec-reviewer 审查
- [ ] 每个 implementer 产出已通过 quality-reviewer 审查
- [ ] Review loop 通过（每任务 spec + quality 双通过）
- [ ] 子代理发现的计划外问题已处理
- [ ] 所有并行任务产出已整合
