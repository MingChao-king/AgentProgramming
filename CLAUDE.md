# SuperProgramming — 插件开发指南

## 开发哲学

SuperProgramming 自身的开发也遵循 SuperProgramming 方法论。这是递归的 —— 我们用来构建插件的方法论，就是插件本身所倡导的方法论。

## 如果你是 AI Agent

在对此仓库提出任何 PR 之前：

1. **遵循 brainstorming 技能**：澄清需求 → 勘探项目 → 大纲先行
2. **遵循 writing-plans 技能**：拆分任务 → 防重复检查 → L2/L3 查找
3. **遵循 TDD 技能**：先写测试 → 最小实现 → L4 验证
4. **遵循 closing-the-loop 技能**：钢印 5 项 → 回写 → 推送

## 项目结构

```
AgentProgramming/
├── .claude-plugin/          # Claude Code 插件配置
│   ├── plugin.json          # 插件元数据
│   └── marketplace.json     # 市场注册
├── hooks/                   # 插件钩子
│   ├── hooks.json           # Hook 定义
│   ├── session-start        # SessionStart 引导注入脚本
│   └── run-hook.cmd         # Windows 适配器
├── skills/                  # 技能库
│   ├── using-agent-programming/   # 引导技能
│   ├── brainstorming/             # 需求澄清 + L4 勘探
│   ├── writing-plans/             # 任务规划 + 防重复
│   ├── test-driven-development/   # TDD + L4 验证
│   ├── subagent-driven-development/
│   ├── systematic-debugging/
│   ├── requesting-code-review/
│   ├── verification-before-completion/
│   ├── closing-the-loop/          # 回写闭环
│   ├── using-git-worktrees/
│   └── finishing-a-development-branch/
├── knowledge-base/          # 知识库（git 管理）
├── README.md
├── CLAUDE.md                # 本文件
└── LICENSE
```

## 贡献流程

### 1. 理解问题

使用 brainstorming 技能澄清你要解决的问题。不要直接跳到代码。

### 2. 设计大纲

在对话中写出 mini 设计大纲：
- 要做什么 + 为什么
- 涉及哪些文件
- 怎么改
- 影响范围
- 验证方式

### 3. 实现

遵循 TDD（如果适用）。确保你的更改：
- 不破坏现有技能的行为
- 与 AgentProgramming 的哲学一致（大纲先行、防重复、闭环积累）
- 更新相关文档（README.md、技能文件中的引用）

### 4. 验证

- 在 Claude Code 中测试你的更改
- 确保 SessionStart hook 正确注入引导内容
- 确保技能可以通过 `Skill` 工具正确调用

### 5. 回写

- 更新知识库中的 L3（AgentProgramming-experience.md）
- 追加 Roadmap（AgentProgramming-roadmap.md）
- Commit message 格式：`roadmap: AgentProgramming - {描述}`

## 技能编写规范

每个技能文件（SKILL.md）必须：

1. **包含 frontmatter**：`name` 和 `description`（必填），`when_to_use`（可选）
2. **声明技能类型**：刚性（严格遵循）或柔性（适配上下文）
3. **包含 Red Flags 表**：列出常见的合理化借口及反驳
4. **包含完成标准**：可勾选的 checklist
5. **使用强制性语言**：不是"建议"，是"必须"

## PR 提交要求

- PR 标题清晰描述变更
- 包含变更动机（解决的问题）
- 包含验证方式
- 标注技能类型变更（如有）

## 许可证

MIT License — 详见 [LICENSE](LICENSE)
