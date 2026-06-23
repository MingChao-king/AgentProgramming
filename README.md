# SuperProgramming v3.0

> Claude Code 插件 — 结构化开发工作流 + Roadmap 统一真相源 + 功能级细粒度质量保证

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-3.0.0-blue.svg)](.claude-plugin/plugin.json)

## v3.0 核心变更

**12 → 5 技能精简。Roadmap 6 节统一真相源（取消 experience.md）。逐功能 TDD → 审查 → 测试。**

| v2.x | v3.0 |
|------|------|
| 12 个技能，职责分散 | **5 个技能**，核心流程内聚 |
| experience.md + roadmap.md 双文件 | **Roadmap 6 节**，一个文件追溯全部 |
| 阶段结束后统一审查+测试 | **逐功能** TDD → 8维审查 → 全量测试 |
| 单层测试 | **两层测试**：子功能全量 + 全场景集成 |

## 快速开始

### 安装

```bash
cd /path/to/SuperProgramming
/plugin install .
```

### 使用

安装后不需要做任何特殊操作。当你说"帮我做一个 XXX"时，Agent 自动：

1. **Brainstorming**：需求澄清 + 项目类型检测 + L4 勘探 + 大纲先行 → 保存 6 节 roadmap
2. **Writing Plans**：功能拆分(TDD三元组) + roadmap §4 防重复 + L2 复用标注
3. **Implementing**：逐功能 TDD(RED→GREEN→REFACTOR) → subagent 8维审查 → 子功能全量测试 → 全场景集成测试
4. **Closing the Loop**：闭环确认 + roadmap 更新 + 跨项目经验提炼 + 分支收尾

## 工作流

```
新功能/修改/重构:
  brainstorming → writing-plans → implementing(逐功能: TDD→审查→测试) → closing-the-loop

Bug 修复:
  brainstorming → implementing(Bug模式) → closing-the-loop

紧急修复:
  hotfix（用户显式调用 skill:hotfix）
```

## 5 个技能

| 技能 | 类型 | 触发 |
|------|------|------|
| `brainstorming` | 柔性 | 任何编码前 |
| `writing-plans` | 柔性 | 设计获批后 |
| `implementing` | **刚性** | 实现阶段（TDD → 审查 → 测试） |
| `closing-the-loop` | **刚性** | 所有任务完成后 |
| `hotfix` | 柔性 | 用户显式调用 `skill:hotfix` |

## Roadmap 6 节结构（唯一真相源）

```
§1. 项目概览 — 技术栈、架构决策、项目类型
§2. 阶段规划 — 阶段目标 + Feature 清单 + 状态
§3. 接口清单 — API / 前端组件路由 / 插件技能+Hook（按类型自适应）
§4. 现有封装方法索引 — 防重复造轮子
§5. 实现记录 — 每功能审查结果、测试覆盖、边界情况
§6. 经验提炼 — 踩坑 + 可跨项目复用模式
```

## 四级缓存知识体系

| 层级 | 内容 | 更新频率 |
|------|------|----------|
| L1 守则 | agent编程守则.md（方法论） | 极少 |
| L2 通用经验 | 通用编码经验.md（跨项目模式） | 发现通用解法时 |
| L3 项目速查 | Roadmap（6节统一真相源） | 每次任务后 |
| L4 源码 | 项目源代码 | 实时（唯一真相源） |

## 哲学

- **大纲先行** — 写任何代码前，必须先有设计大纲
- **L4 是唯一真相源** — 缓存可能过期，源码不会
- **一功能一测一审** — 质量内建于每个子功能，而非阶段末尾补
- **Roadmap 唯一真相源** — 设计 + 接口 + 经验 + 进度全在一个文件
- **TDD 不是选项** — 先写测试，看到它失败，再写代码
- **闭环积累** — 每次任务不只是完成任务，是为未来积累资产

## 许可证

MIT License — 详见 [LICENSE](LICENSE)
