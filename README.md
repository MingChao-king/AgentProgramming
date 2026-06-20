# AgentProgramming

> 融合 [Superpowers](https://github.com/obra/superpowers) 的结构化开发工作流与四级缓存知识体系的新一代 Claude Code 插件。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](.claude-plugin/plugin.json)

## 为什么选择 AgentProgramming？

| 能力 | Superpowers | Agent-Programming | **AgentProgramming (本插件)** |
|------|:-----------:|:-----------------:|:-----------------------------:|
| 结构化工作流 | ✅ | ❌ | ✅ **两者融合** |
| 苏格拉底式需求澄清 | ✅ | ❌ | ✅ + L4 项目勘探 |
| TDD 强制执行 | ✅ | ❌ | ✅ + L4 签名验证 |
| 子代理并行开发 | ✅ | ❌ | ✅ + 防重复检查 |
| 系统化调试 | ✅ | ❌ | ✅ + L4 唯一真相源 |
| 大纲先行 | ❌ | ✅ | ✅ **保留** |
| 防重复造轮子 | ❌ | ✅ | ✅ **保留** |
| 跨项目经验积累(L2) | ❌ | ✅ | ✅ **保留** |
| 项目速查缓存(L3) | ❌ | ✅ | ✅ **保留** |
| 回写闭环 | ❌ | ✅ | ✅ **保留** |
| Roadmap 追踪 | ❌ | ✅ | ✅ **保留** |

**AgentProgramming = Superpowers 的工作流引擎 + Agent-Programming 的知识积累体系**

## 快速开始

### 安装

#### 从本地安装

```bash
cd /path/to/AgentProgramming
/plugin install .
```

#### 从 Marketplace 安装

```bash
# 注册市场
/plugin marketplace add MingChao-king/SuperProgramming

# 安装插件
/plugin install superprogramming@superprogramming-marketplace
```

### 使用

安装后，**不需要做任何特殊操作**。在新会话开始时，AgentProgramming 会自动注入引导内容。当你说"帮我做一个 XXX"时，Agent 会自动：

1. **Brainstorming**：澄清需求 + 探索项目结构 + 产出设计大纲
2. **Writing Plans**：拆分任务 + 检查可复用组件 + 搜索最优模式
3. **TDD Implementation**：先写测试 → 写最小代码 → L4 验证 → 重构
4. **Code Review**：对照计划审查
5. **Closing the Loop**：积累经验到知识库（L2/L3）+ 更新 Roadmap
6. **Finish**：合并/PR

## 六阶段工作流

```
SessionStart（自动注入）
  → 阶段一：理解（brainstorming + L4 勘探 + 大纲先行）
  → 阶段二：规划（writing-plans + 防重复 + L2/L3 查找）
  → 阶段三：实现（TDD + subagent + L4 验证 + 系统调试）
  → 阶段四：验证（code-review + verification + 冒烟测试）
  → 阶段五：闭环（closing-the-loop — 钢印 5 项 + 回写 L2/L3）
  → 阶段六：收尾（finishing-a-development-branch）
```

## 技能列表

### 流程技能

| 技能 | 用途 | 类型 |
|------|------|------|
| `using-agent-programming` | 引导技能，介绍整个方法论 | 刚性 |
| `brainstorming` | 需求澄清 + L4 勘探 + 大纲先行 | 柔性 |
| `writing-plans` | 任务规划 + 防重复检查 + L2/L3 利用 | 柔性 |
| `test-driven-development` | TDD 红-绿-重构 + L4 签名验证 | 刚性 |
| `subagent-driven-development` | 子代理并行执行 | 柔性 |
| `closing-the-loop` | 钢印 5 项 + 回写 L2/L3 + 推送知识库 | 刚性 |
| `finishing-a-development-branch` | 分支合并/PR/清理 | 柔性 |

### 质量技能

| 技能 | 用途 | 类型 |
|------|------|------|
| `systematic-debugging` | 四阶段根因分析 + L4 仲裁 | 刚性 |
| `requesting-code-review` | 对照计划审查 + L3 契约检查 | 柔性 |
| `verification-before-completion` | 确认修复 + 冒烟测试 | 刚性 |

### 基础设施技能

| 技能 | 用途 | 类型 |
|------|------|------|
| `using-git-worktrees` | Git 工作树隔离 | 柔性 |

## 四级缓存知识体系

这是 AgentProgramming 独有的优势 — **让每次开发都为未来积累资产**：

| 层级 | 类比 | 内容 | 更新频率 |
|------|------|------|----------|
| L1 守则 | 大脑思考方式 | agent编程守则.md（方法论） | 极少 |
| L2 通用经验 | 大脑知识库 | 通用编码经验.md（跨项目模式） | 每次发现通用解法时 |
| L3 项目速查 | 环境速查表 | {项目}-experience.md（≥150行） | 每次任务后 |
| L4 源码 | 外部世界 | 项目源代码 | 实时（唯一真相源） |

## 哲学

- **大纲先行** — 写任何代码前，必须先有设计大纲
- **L4 是唯一真相源** — 缓存可能过期，源码不会
- **防重复造轮子** — 7 项强制检查，复用优于重写
- **闭环积累** — 每次任务不只是完成任务，是为未来积累资产
- **TDD 不是选项** — 先写测试，看到它失败，再写代码
- **验证而非猜测** — 跑起来看，不要"应该没问题"

## 与 Superpowers 的关系

AgentProgramming 灵感来源于 Superpowers，吸收了它的结构化工作流引擎（brainstorming → plans → TDD → review → finish），并在此基础上增加了四级缓存知识体系 —— 这是两者最根本的区别。

**Superpowers 让每次任务结构化执行。AgentProgramming 让每次任务都为下一次加速。**

## 许可证

MIT License — 详见 [LICENSE](LICENSE) 文件

## 社区

- **仓库**: https://github.com/MingChao-king/SuperProgramming
- **问题反馈**: https://github.com/MingChao-king/SuperProgramming/issues
