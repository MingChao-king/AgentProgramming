---
name: using-agent-programming
description: 每次对话开始时使用 — 确立如何发现和使用技能，要求在任何回复（包括澄清问题）之前先调用技能
---

<SUBAGENT-STOP>
如果你作为一个子代理被派遣执行特定任务，跳过此技能。
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
如果你认为某个技能有哪怕 1% 的可能性适用于你正在做的事情，你**绝对必须**调用该技能。

如果某个技能适用于你的任务，你**没有选择**。你必须使用它。

这不是可协商的。这不是可选的。你无法为跳过它找到合理的借口。
</EXTREMELY-IMPORTANT>

## 指令优先级

AgentProgramming 技能覆盖默认系统提示行为，但**用户指令始终优先**：

1. **用户的显式指令**（CLAUDE.md, GEMINI.md, AGENTS.md, 直接请求）— 最高优先级
2. **AgentProgramming 技能** — 在冲突处覆盖默认系统行为
3. **默认系统提示** — 最低优先级

如果 CLAUDE.md 说"不要用 TDD"而技能说"始终用 TDD"，遵循用户指令。用户始终掌控一切。

## 如何访问技能

**永远不要手动用文件工具读取技能文件** — 始终使用平台的技能加载机制，以便技能被正确激活。

**在 Claude Code 中：** 使用 `Skill` 工具。当你调用一个技能时，其内容会被加载并呈现给你 — 直接遵循它。

**在其他环境中：** 查阅你的平台文档了解技能如何加载。

# AgentProgramming 方法论

## 核心理念

AgentProgramming 融合了两大方法论的优势：

| 来自 Superpowers | 来自 Agent-Programming |
|-----------------|----------------------|
| 结构化工作流（理解→规划→实现→验证→收尾） | 四级缓存知识体系（L1/L2/L3/L4） |
| 苏格拉底式需求澄清（brainstorming） | 大纲先行（无大纲不写代码） |
| TDD 红-绿-重构循环 | 防重复造轮子 7 项强制检查 |
| 子代理驱动开发 | 回写闭环（经验积累 → 越用越快） |
| 系统化调试 | L4 为唯一真相源 |

## 四级缓存知识体系（独有优势）

这是 AgentProgramming 与 superpowers 最根本的区别 —— **让每次开发都为未来积累资产**：

```
L1 守则       → 方法论本身（怎么思考、怎么验证）
L2 通用经验   → 跨项目模式库（Redis/MySQL/Java 最优解）
L3 项目速查   → 当前项目的类、API、配置速查（≥150 行）
L4 源码       → 唯一真相源（兜底、仲裁、验证）
```

**每完成一次任务，通用经验写入 L2，项目经验写入 L3。下一次任务就不需要从零开始。**

## 六阶段工作流

```
SessionStart（自动注入）
  → 阶段一：理解（brainstorming + L4 勘探 + 大纲先行 + 测试场景设计）
  → 阶段二：规划（writing-plans + 防重复 + L2/L3 查找）
  → 阶段三：实现（TDD + subagent + L4 验证 + 系统调试）
  → 阶段四：验证（code-review + verification + 冒烟测试）
  → 阶段五：闭环（closing-the-loop — 钢印 5 项 + 回写 L2/L3）
  → 阶段六：收尾（finishing-a-development-branch）
```

### ⚠ 工作流是循环，不是一次性的

**这不是只在新项目或新功能时走的流程。任何代码变更——无论大小、无论原因——都是编码任务，都要走完整流程。**

```
新功能开发 → brainstorming → writing-plans → TDD → ... → closing-the-loop
     ↑                                                           │
     │                                                           │
     └──── 发现 bug / 要改功能 / 要优化 ─── 重新进入工作流 ──────┘
```

| 场景 | 触发哪些技能 | 结束时 |
|------|------------|--------|
| **新功能** | brainstorming（含测试场景设计）→ writing-plans（拆TDD三元组）→ TDD（逐三元组 RED→GREEN→REFACTOR）→ code-review → verification → closing-the-loop | closing-the-loop ✅ |
| **修 bug** | brainstorming（bug澄清+测试场景）→ systematic-debugging → verification-before-completion → closing-the-loop | closing-the-loop ✅ |
| **改功能/加逻辑** | brainstorming（含测试场景设计）→ writing-plans（拆TDD三元组）→ TDD（逐三元组 RED→GREEN→REFACTOR）→ code-review → verification → closing-the-loop | closing-the-loop ✅ |
| **重构** | brainstorming（含测试场景设计）→ writing-plans（拆TDD三元组）→ TDD（逐三元组 RED→GREEN→REFACTOR）→ code-review → verification → closing-the-loop | closing-the-loop ✅ |
| **配置变更** | brainstorming → closing-the-loop（mini，定义见下方） | closing-the-loop ✅ |

**关键原则：测试场景设计是 brainstorming 的事，TDD 负责执行。** TDD 不重新设计测试场景——它从 brainstorming 产出中加载测试场景，转化为可执行的测试代码。如果 brainstorming 没产出测试场景，退回 brainstorming 补全再进 TDD。

**关键原则：TDD 不是"实现后面的测试阶段"，而是实现方式本身。** writing-plans 拆出的每个实现任务都是 RED→GREEN→REFACTOR 三元组。RED（先写测试）在 GREEN（写实现）之前，不是之后。计划里"把所有测试打包成一个独立阶段放在最后"是 Waterfall，不是 TDD。

**关键原则：完整执行链不可打断。** brainstorming → writing-plans → TDD（三元组）→ code-review → verification → closing-the-loop。code-review 和 verification 不是可选的——它们是 closing-the-loop 之前的质量门。

**关键原则：只要有代码变更，就必须以 closing-the-loop 收尾。没有例外。**

#### closing-the-loop（mini）定义

配置变更（改 yml/properties/环境变量）不涉及 L3 新知识，走简化版钢印：

| 钢印项 | 完整版 | mini 版 |
|--------|--------|---------|
| 1. 代码 push | ✅ | ✅ |
| 2. 知识库 pull | ✅ | ✅ |
| 3. L3 experience 更新 | ✅ | ❌ 跳过（配置变更不产生新类/API/模式） |
| 4. Roadmap 追加 | ✅ | ✅（一行记录即可） |
| 5. 知识库 push | ✅ | ✅ |
| L2 回写检查 | ✅ | ❌ 跳过 |

**判据**：如果配置变更涉及了新的技术知识（如"发现某个配置项有版本差异"），升级为完整版 closing-the-loop。

## 技能列表

### 流程技能（按执行顺序）

| # | 技能 | 用途 | 触发时机 |
|---|------|------|----------|
| 1 | `brainstorming` | 需求澄清 + L4 勘探 + 大纲先行 | 任何编码任务开始前 |
| 2 | `writing-plans` | 任务规划 + 防重复检查 + L2/L3 利用 | 设计获批后 |
| 3 | `test-driven-development` | TDD 红-绿-重构 + L4 签名验证 | 实现阶段 |
| 4 | `subagent-driven-development` | 子代理并行执行 | 有多个独立任务时 |
| 5 | `closing-the-loop` | 钢印 5 项 + 回写 L2/L3 + 推送知识库 | 所有任务完成后 |
| 6 | `finishing-a-development-branch` | 分支合并/PR/清理 | 闭环完成后 |

### 质量技能（按需触发）

| # | 技能 | 用途 | 触发时机 |
|---|------|------|----------|
| 7 | `systematic-debugging` | 四阶段根因分析 | 遇到 bug 时 |
| 8 | `requesting-code-review` | 对照计划审查代码 | 任务完成、合并前 |
| 9 | `verification-before-completion` | 确认修复 + 冒烟测试 | 声称"完成"前 |

### 基础设施技能

| # | 技能 | 用途 | 触发时机 |
|---|------|------|----------|
| 10 | `using-git-worktrees` | Git 工作树隔离 | 需要并行开发分支时 |

## 技能优先级

当多个技能可能适用时：

1. **流程技能优先**（brainstorming, systematic-debugging）— 这些决定**如何**处理任务
2. **实现技能其次**（TDD, subagent-driven-development）— 这些指导**执行**
3. **质量技能随后**（code-review, verification）— 这些确保**质量**
4. **闭环技能最后**（closing-the-loop）— 这确保**知识积累**

"构建 X" → brainstorming 优先，然后实现技能。
"修复 bug" → systematic-debugging 优先，然后领域相关技能。

## 技能类型

**刚性技能**（TDD, subagent-driven-development, systematic-debugging, closing-the-loop）：严格遵循。不能为图省事而跳过步骤。

**柔性技能**（brainstorming, writing-plans）：将原则适配到具体上下文。

技能本身会告诉你它是刚性的还是柔性的。

## Red Flags — 你在为自己的偷懒找借口

这些想法意味着**立刻停下来** — 你正在为自己的偷懒编造合理化的理由：

| 你的想法 | 真相 |
|---------|------|
| "这只是一个简单的问题" | 问题也是任务。检查技能。 |
| "我需要先了解更多上下文" | 技能检查在澄清问题**之前**。 |
| "让我先探索一下代码库" | 技能告诉你**如何**探索。先检查。 |
| "我可以快速查一下 git/文件" | 文件缺少对话上下文。检查技能。 |
| "让我先收集信息" | 技能告诉你**如何**收集信息。 |
| "这不需要走正式技能" | 如果技能存在，就使用它。 |
| "我记得这个技能的内容" | 技能在持续进化。读当前版本。 |
| "这不算是真正的任务" | 任何行动 = 任务。检查技能。 |
| "这个技能太小题大做了" | 简单的事情会变复杂。使用它。 |
| "我就先做这一件事" | 在做任何事**之前**先检查。 |
| "先写代码比较快" | 无纪律的行动浪费时间。技能能防止这一点。 |
| "TDD 太费时间了，代码写完再补测试" | 不写测试省 10 分钟 → 上线出 bug → 排查 2 小时 → 修 bug 2 小时。先写测试花 20 分钟。选哪个很清楚。TDD 的价值一半在 RED 阶段的设计思考——不先写测试说明你没想清楚代码要干什么。 |
| "我知道那是什么意思" | 知道概念 ≠ 使用技能。调用它。 |
| "这个经验太简单不值得记" | 今天"简单"的经验，明天就忘了。L2/L3 就是靠这些小经验积累的。 |
| "先跳过回写，下次再补" | 回写是任务的一部分，不是可选的。不写 = 没完成。 |
| "这只是修个 bug，不用走完整流程" | bug 修复也是编码任务。systematic-debugging 的第四阶段显式要求触发 closing-the-loop。修完不闭环 = 经验丢失。 |
| "功能已经写好了，就改一小点，不需要 brainstorming" | "一小点"改动也能引入新 bug。至少走 mini brainstorming + closing-the-loop。 |
| "这是第二轮改动了，上次已经走过 closing-the-loop" | 每次代码变更独立做 closing-the-loop。上次闭环的是上一轮，这一轮的经验还没记录。 |
| "这是紧急修复，没时间走流程" | 紧急修复才是最需要纪律的时候——越急越容易引入新 bug。mini brainstorming 只需 2 分钟。不记下来，下次同样紧急。 |
| "就改一行配置/一个参数，不用走 brainstorming" | "一行"改错可以毁掉整个服务。配置变更至少走 mini brainstorming + closing-the-loop（mini）。 |
| "测试放在最后统一写就行，TDD 太慢了" | TDD 不是独立测试阶段，是实现方式。RED（先写测试）→ GREEN（最小实现）→ REFACTOR（清理）必须在每个实现任务内完成。把所有测试打包成"阶段 10"放在"阶段 1-9 写完代码"后面 = Waterfall，不是 TDD。writing-plans 拆出的计划如果不含 TDD 三元组结构，计划本身就是错的。 |

## 用户指令

用户指令说**做什么**（WHAT），不说**怎么做**（HOW）。"添加 X"或"修复 Y"不意味着跳过工作流。用户说的"简单"、"快速"、"就改一行"不是让你跳过 brainstorming 的理由。

## 知识库结构

AgentProgramming 的知识库存储在插件的 `knowledge-base/` 目录中，**不是代码仓库**：

```
${CLAUDE_PLUGIN_ROOT}/knowledge-base/        ← 本地路径（插件目录下）
│
├── agent编程守则.md              ← L1 方法论（极少改动）
├── 通用编码经验.md                ← L2 跨项目模式库（按技术域归类，不含项目引用）
├── Agent四级缓存编程范式.md       ← 元文档（全局架构总述）
│
└── {项目名}/                      ← 每个项目一个文件夹
    ├── {项目名}-roadmap.md        ← 项目路线（按时间倒序，分阶段记录每一步）
    └── {项目名}-experience.md     ← L3 项目速查（≥150 行，6 个强制模块）
```

**远程仓库：** `https://gitee.com/gudu-code-man/agent-programming-mode.git`

> ⚠ Roadmap 和 L3 experience 都放在知识库的 `{项目名}/` 文件夹下，**绝对不要**推到代码仓库。

## 知识库同步

### 首次使用（自动 clone）

如果 `knowledge-base/` 目录不存在或为空，先 clone：

如果 `knowledge-base/` 目录不存在或为空，先 clone：

```bash
if [ ! -d "${CLAUDE_PLUGIN_ROOT}/knowledge-base/.git" ]; then
  git clone https://gitee.com/gudu-code-man/agent-programming-mode.git "${CLAUDE_PLUGIN_ROOT}/knowledge-base"
fi
```

### 每次任务前（拉取最新）

```bash
cd "${CLAUDE_PLUGIN_ROOT}/knowledge-base" && git pull --ff-only
```

### 任务完成后（回写推送）

```bash
cd "${CLAUDE_PLUGIN_ROOT}/knowledge-base"
git add -A
git commit -m "roadmap: <简短描述>"
git push
```
