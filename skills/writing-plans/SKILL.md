---
name: writing-plans
description: 获得批准的设计后激活。将工作拆分为 TDD 三元组任务（RED→GREEN→REFACTOR），执行防重复造轮子检查，利用 L2/L3 缓存最大化复用。柔性技能。
---

<EXTREMELY-IMPORTANT>
设计大纲批准后，你必须使用此技能来制定实施计划。
每个实现任务必须拆成 RED→GREEN→REFACTOR 三元组。不允许"先写代码后补测试"。
计划末尾必须包含 code-review、verification、closing-the-loop 三个收尾阶段。
</EXTREMELY-IMPORTANT>

# Writing Plans：任务规划 + 防重复 + 缓存利用

## 技能类型：柔性

任务拆分的粒度和分组可适配上下文，但 TDD 三元组结构、防重复检查、L2/L3 查找、执行链完整性是强制的。

---

## 执行链约束（不可跳过的完整链条）

**writing-plans 产出的计划不是孤立的任务列表——它是 SuperProgramming 六阶段工作流中的一环。计划结构必须严格对应执行链。**

```
brainstorming（设计测试场景 + 设计大纲）
    │
    ▼
writing-plans（本技能 — 拆分 TDD 三元组 + 标注收尾阶段）
    │
    ▼
┌─────────────────────────────────────────────────────────┐
│  实现阶段（TDD 交织执行）                                  │
│                                                         │
│  对每个业务任务：                                         │
│    RED ──→ GREEN ──→ REFACTOR                           │
│    (先写测试)  (最小实现)  (清理)                          │
│                                                         │
│  注意：是"每个任务内部"的 RED→GREEN→REFACTOR，            │
│        不是"所有任务写完 → 统一测试"                      │
└─────────────────────────────────────────────────────────┘
    │
    ▼
requesting-code-review（对照设计大纲审查代码）
    │
    ▼
verification-before-completion（编译 + 冒烟 + 边界抽查）
    │
    ▼
closing-the-loop（钢印 5 项 + 回写知识库）
    │
    ▼
finishing-a-development-branch（分支合并/PR，如适用）
```

### 计划中必须显式列出的阶段

| 阶段 | 在计划中的位置 | 不可跳过 |
|------|--------------|---------|
| **业务实现** | 按依赖关系排列，每个业务任务 = RED + GREEN + REFACTOR 三个子任务 | ❌ |
| **code-review** | 所有业务任务完成后 | ❌ |
| **verification** | code-review 完成后 | ❌ |
| **closing-the-loop** | verification 完成后 | ❌ |
| **finishing** | closing-the-loop 完成后（分支开发时） | 单分支可合并到 closing-the-loop |

### ❌ 反模式：计划中绝对不允许出现的结构

```
阶段 1-9：写代码（Entity/DTO/Service/Controller/Config...）
阶段 10：TDD 单元测试          ← 这是 Waterfall，不是 TDD
阶段 11：构建验证
（无 closing-the-loop）        ← 经验丢失
```

**TDD 不是"实现后面的测试阶段"。TDD 是实现方式本身。**

---

## 三步工作流

```
设计大纲（来自 brainstorming）
    │
    ▼
第一步：任务拆分（TDD 三元组）
    │ → 每个实现任务 = RED → GREEN → REFACTOR
    ▼
第二步：防重复检查（每项任务执行前）
    │ → 确认没有现成的实现可以复用
    ▼
第三步：L2/L3 缓存利用
    │ → 标注可复用的组件、模式、已有类
    ▼
产出：可执行的 TDD 任务清单 + 收尾阶段
```

---

## 第一步：任务拆分（TDD 三元组模板）

### 核心原则

将工作拆分为**极其具体**的任务。每个任务应该是一个热情的初级工程师也能执行的程度 —— 有确切的文件路径、完整的代码逻辑、明确的验证方式。

**更重要的是：每个实现任务必须拆成 RED → GREEN → REFACTOR 三个子任务。不允许"实现"作为一个单独的任务存在。**

### 任务粒度标准

| 太粗（不好） | 刚好（好） |
|-------------|-----------|
| "实现用户认证" | TDD 三元组：RED(写 auth 测试) → GREEN(实现 generate_token) → REFACTOR(清理) |
| "重构数据库层" | TDD 三元组：RED(先写参数化查询测试) → GREEN(改 SQL) → REFACTOR(提取常量) |
| "加个 API 接口" | TDD 三元组：RED(写接口测试) → GREEN(新增端点) → REFACTOR(统一返回格式) |

### TDD 三元组任务模板

**每个业务任务必须按以下三元组拆分。这是强制的——不允许单行"实现某某"任务。**

```
┌──────────────────────────────────────────────────────────────┐
│  任务组 X：{业务描述}                                         │
│                                                              │
│  X-R  RED：先写测试                                           │
│       ├─ 文件：src/test/.../{ClassName}Test.java              │
│       ├─ 内容：基于 brainstorming 的 4 类场景写测试方法         │
│       ├─ 验证：mvn test → 测试失败（红）                       │
│       └─ 提交：git commit -m "RED: {测试场景描述}"             │
│                                                              │
│  X-G  GREEN：最小实现                                         │
│       ├─ 文件：src/main/.../{ClassName}.java                  │
│       ├─ 内容：只写让 X-R 测试通过的代码，YAGNI                 │
│       ├─ L4 签名验证：Read 至少 3 个调用的关键方法签名           │
│       ├─ 验证：mvn test → 全部通过（绿）                       │
│       ├─ 依赖：X-R（GREEN 依赖 RED，不是反过来）                │
│       └─ 提交：git commit -m "GREEN: {实现描述}"               │
│                                                              │
│  X-F  REFACTOR：清理                                          │
│       ├─ 文件：同 X-G                                        │
│       ├─ 内容：消除重复、改善命名、提取常量、保持测试绿          │
│       ├─ 验证：mvn test → 仍然全部通过                         │
│       ├─ 依赖：X-G                                           │
│       └─ 提交：git commit -m "REFACTOR: {清理描述}"            │
└──────────────────────────────────────────────────────────────┘
```

### 依赖方向规则（关键）

```
❌ 错误：D3 (实现 Service) → T1 (测试 Service)    ← 测试依赖实现 = Waterfall
✅ 正确：T1-R (RED 测试) → T1-G (GREEN 实现) → T1-F (REFACTOR)

任务之间的依赖：
  Service 的 GREEN 可以依赖 Entity/Mapper 的 GREEN（基础设施必须先存在）
  但同一 Service 内部：RED 最先，GREEN 依赖 RED，REFACTOR 依赖 GREEN
```

### 何时可以合并三元组

对于极简单的任务（如纯 Entity、纯 Enum、纯 DTO——无业务逻辑），允许合并为一个任务并标注"无 TDD（纯数据结构）"：

```
| X | 创建 CouponType 枚举 | enums/CouponType.java | 无 TDD（纯枚举，无行为） | 编译通过 |
```

**判据**：文件只包含字段声明/getter/setter/注解，不包含任何 `if`/`for`/`while`/`throw`/`return` 逻辑 → 可以跳过 TDD。有任何一个分支或循环 → 必须走 TDD 三元组。

---

## 第二步：防重复造轮子（强制检查清单）

### ⚠️ 最常见的浪费：写了一个项目中已经存在的东西。

**在规划每个新类/新方法之前，逐项执行以下检查：**

| # | 检查项 | 操作 | 为什么 |
|---|--------|------|--------|
| 1 | 新 Service 方法？ | `Grep "方法名" **/service/**/*.java` | 可能接口已有声明，实现类已有类似方法 |
| 2 | 新 DTO/VO？ | `Glob **/dto/**/*.java`, `Glob **/vo/**/*.java` | 可能已有完全相同的返回结构 |
| 3 | 新工具方法？ | `Grep "方法签名" **/utils/**/*.java`, `Grep "方法签名" **/common/**/*.java` | 项目工具类可能已经封装了 |
| 4 | 新 Mapper/Repository 方法？ | `Grep "方法名" **/mapper/**/*.java`, `Grep "方法名" **/repository/**/*.java` | ORM 内置方法可能已覆盖 |
| 5 | 新常量/枚举？ | `Grep "常量名" **/enums/**`, `Glob **/constants/**` | 避免重复定义 |
| 6 | 新依赖？ | `Grep "artifactId" pom.xml` 或 `build.gradle` | 依赖可能已引入但你不知道 |
| 7 | 功能相似方法？ | `Grep "业务关键词" **/*.java` 模糊搜索 | 换个名字但功能完全一样的方法 |

### 判据：满足以下任一条 → 停止规划新代码，标注"复用已有"

- 已有方法名只差一两个单词，参数列表基本相同
- 已有 DTO 字段覆盖了你需要的 80% 以上（剩余 20% 扩展字段即可）
- 已有工具方法逻辑相同，只是入参类型不同

---

## 第三步：L2/L3 缓存利用

### L3 项目速查（有什么可以复用）

从 brainstorming 阶段的 L4 勘探结果和 L3 缓存中，标注每个任务可以复用的组件：

```
任务组 T1：CouponTemplateService
  T1-R (RED) → 复用：参考已有 Service 测试模式（XxxServiceTest）
  T1-G (GREEN) → 复用：BaseEntity 的 createTime/updateTime
  T1-G (GREEN) → 复用：MyMetaObjectHandler 自动填充
```

### L2 跨项目模式（怎么写最优）

在 L2 通用编码经验中搜索当前问题域的最优解：

| 当前任务涉及的场景 | 搜索 L2 的关键词 | 预期命中 |
|-------------------|-----------------|---------|
| 数据分页 | "分页" "Page" "滚动分页" | 滚动分页模式 / MyBatis-Plus 分页 |
| 缓存策略 | "缓存" "Redis" "穿透" | 缓存穿透通用解法 / Redis BitMap |
| 排序保持 | "排序" "ORDER BY FIELD" | MySQL IN 查询保持顺序 |
| 并发控制 | "锁" "乐观锁" "幂等" | 乐观锁 vs 悲观锁选择 |

**L2 命中 → 按模式写代码。L2 未命中 → 放慢速度，精读 L4 源码后谨慎写。任务完成后回写 L2。**

---

## 任务清单格式

### 最终输出的完整格式

```markdown
## 实施计划：{功能名称}

> 关联设计大纲：roadmap {阶段}
> 涉及模块：{模块列表}

### 复用组件汇总

| 已有组件 | 路径 | 用于任务 |
|---------|------|---------|
| BaseEntity | common-core/.../entity/BaseEntity.java | 所有实体继承 |
| Result<T> | common-core/.../result/Result.java | 所有 Controller 返回 |

### 阶段 1-N：业务实现（TDD 交织）

> **执行规则**：每个任务组先 RED（写测试→失败）→ GREEN（最小实现+验 L4）→ REFACTOR（清理）。
> 不是"写完所有代码再测试"。测试先于实现，不是实现先于测试。

#### 任务组 X：{业务描述}

| # | 子任务 | 文件 | 要点 | 验证 | 依赖 |
|---|--------|------|------|------|------|
| X-R | RED: {测试描述} | src/test/.../XxxTest.java | 4类场景→测试方法 | mvn test → FAIL | — |
| X-G | GREEN: {实现描述} | src/main/.../Xxx.java | 最小实现+L4验≥3签名 | mvn test → PASS | X-R |
| X-F | REFACTOR: {清理描述} | 同 X-G | DRY+命名+常量 | mvn test → PASS | X-G |

#### 纯数据结构任务（无 TDD）

| # | 任务 | 文件 | 要点 | 验证 | 依赖 |
|---|------|------|------|------|------|
| B1 | 创建 XxxEnum | enums/XxxEnum.java | 无 TDD（纯枚举，无行为） | 编译通过 | — |

### 阶段 N：Code Review

| # | 任务 | 操作 | 验证 |
|---|------|------|------|
| R1 | 对照设计大纲审查 | 调用 requesting-code-review 技能 | 审查意见全部处理完毕 |
| R2 | 对照 brainstorming 测试场景核对 | 确认全部测试场景有对应测试覆盖 | 12/12 场景已覆盖 |

### 阶段 N+1：Verification

| # | 任务 | 操作 | 验证 |
|---|------|------|------|
| V1 | 全量编译 | mvn clean install -DskipTests | 0 错误 |
| V2 | 全部测试 | mvn test | 全部通过 |
| V3 | 冒烟测试 | 启动服务 → 关键 API 手动验证 | 全部 200 |
| V4 | 边界抽查 | 抽查 3 个边界条件（null/空/极值） | 行为符合预期 |

### 阶段 N+2：Closing the Loop

| # | 任务 | 操作 | 验证 |
|---|------|------|------|
| CL1 | 代码推送 | git add -A && git commit && git push | git status 干净 |
| CL2 | 知识库拉取 | cd knowledge-base && git pull --ff-only | Already up to date |
| CL3 | L3 回写 | 子代理更新 experience.md | 新类/API/模式已记录 |
| CL4 | Roadmap 追加 | 子代理追加实现记录 | 新行已添加 |
| CL5 | L2 检查 | 子代理检查通用编码经验 | 有则回写，无则记录"本次无" |
| CL6 | 知识库推送 | git add -A && git commit && git push | 推送成功 |

### 依赖关系图

```
阶段 1 (基础设施: Entity/Enum/Mapper — 纯数据结构)
  └→阶段 2 (Service Group 1: RED→GREEN→REFACTOR)
       └→阶段 3 (Service Group 2: RED→GREEN→REFACTOR)
            └→阶段 4 (Controller: RED→GREEN→REFACTOR)
                 └→阶段 5 (Config + 跨模块)
                      └→阶段 6 (Consumer: RED→GREEN→REFACTOR)
                           └→阶段 N (Code Review)
                                └→阶段 N+1 (Verification)
                                     └→阶段 N+2 (Closing the Loop)
```
```

---

## Red Flags — 你的计划有结构性问题

| 你的想法 | 真相 |
|---------|------|
| "写一个新的更快，搜索已有的太慢" | 写新的 5 分钟 + 调试 20 分钟 + 后续维护。搜索已有 2 分钟。哪个更快？ |
| "这个功能太特殊了，肯定没有现成的" | 你 7 次搜索里有 3 次能找到可复用的。不要靠直觉，靠 Grep。 |
| "已有的那个不太一样，我重写一个更干净" | 扩展已有类比新建类更好。不要为了一个字段新建一个 DTO。 |
| "L2 里没有这个场景的模式" | 那你就有责任在这次任务完成后将其写入 L2。 |
| "就加一个字段，不需要查 L3" | L3 里有这个类的完整字段列表吗？如果超 7 天，需要验证。 |
| **"先把所有实现任务列完，测试放最后一个阶段就行"** | **这是 Waterfall，不是 TDD。TDD 要求每个实现任务前面有 RED（先写测试），后面有 REFACTOR（清理）。测试不是"实现后面的阶段"——测试是实现的第一步。** |
| **"测试任务依赖实现任务，所以实现必须先做完"** | **依赖方向反了。RED 测试先写，GREEN 实现依赖 RED 测试（实现要"让测试通过"）。正确顺序：写测试 → 测试失败 → 写实现 → 测试通过 → 清理。** |
| **"收尾阶段（review/verification/closing）不属于计划的一部分"** | **这些不是"可选的收尾"——它们是交付的必选阶段。计划末尾没有 code-review + verification + closing-the-loop = 计划不完整。** |
| **"纯数据结构的任务（Entity/DTO）也要走 TDD 三元组"** | 只含字段/注解/getter/setter 的无行为类可以跳过 TDD。但一旦有 `if`/`throw`/`return` 逻辑 → 必须三元组。 |
| **"计划就是任务列表，执行链是执行时的事"** | 计划结构决定执行结构。如果计划里测试放在最后一个阶段，执行时就会变成"写完代码再补测试"。计划必须显式展示 TDD 交织结构。 |

---

## 完成标准

在进入实现阶段之前，你必须确认：

- [ ] 所有业务任务已拆分为 RED → GREEN → REFACTOR 三元组（纯数据结构除外）
- [ ] 每个三元组的依赖方向正确：GREEN 依赖 RED，REFACTOR 依赖 GREEN
- [ ] 每个三元组有明确的文件路径、测试内容、验证方式
- [ ] 防重复 7 项检查已逐项执行
- [ ] 每个任务标注了可复用的已有组件（L3 命中）
- [ ] L2 搜索已完成，相关模式已标注
- [ ] 计划末尾显式列出了 Code Review 阶段
- [ ] 计划末尾显式列出了 Verification 阶段（编译 + 测试 + 冒烟 + 边界抽查）
- [ ] 计划末尾显式列出了 Closing the Loop 阶段（钢印 5 项 + L2/L3 回写）
- [ ] 无"测试阶段"作为独立的后期阶段（测试已交织在每个业务任务的三元组中）
- [ ] 用户已确认任务清单
