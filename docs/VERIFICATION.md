# 验证方法

## 1. 验证闭环

```text
需求拆分 → 测试点矩阵 → directed/stress case
        → scoreboard/SVA/watchdog → 回归结果 → 缺口回填
```

SystemC 模型用于较早验证事务语义、资源生命周期和性能趋势；RTL/UVM 环境进一步验证周期级握手、并发冲突、断言和覆盖率。

## 2. 核心验证维度

| 维度 | 代表场景 | 主要检查 |
| --- | --- | --- |
| 准入仲裁 | 同 target 读写竞争、QoS、owner tie | 单一 owner 持有、grant 顺序、正确 release |
| 调度注入 | AW/W/AR、busy port、read slot | 不覆盖 active slot、不串 ID |
| Mesh 路由 | 多 target、路径冲突、边界端口 | 不丢 beat、不乱序、路径跟随一致 |
| 返回路径 | path 建表、lookup、slot 匹配 | RDATA、RID、RLAST 与请求一致 |
| 存储一致性 | write-read、多 master、多节点 | reference model 与 DUT 数据一致 |
| 可进展性 | hotspot、长 burst、随机反压 | watchdog 不超时、最终状态清空 |

## 3. 检查手段

- Scoreboard：维护参考存储状态，比较写后读数据；
- SVA：检查 valid/ready 稳定性、响应配对和协议边界；
- 生命周期账本：请求数、响应数、logical/mesh/delivered beat 数必须闭合；
- Watchdog：记录 no-progress age，发现永久 busy 或 slot 泄漏；
- 最终清空检查：所有已接受事务完成，active slot、lease 和 FIFO 回到空闲状态。

## 4. 覆盖率口径

阶段性回归包含基础读写、owner sweep、node sweep、long burst、contention、backpressure 和混合压力场景。功能覆盖用于衡量 owner、target、burst、QoS 和内部状态组合；代码覆盖的 condition、FSM 和 toggle 缺口需要继续通过定向用例补强。

公开版没有携带商业 UVM 仿真环境及原始 URG 数据，因此 README 中的覆盖率标记为“阶段性历史回归”，避免把它误解为展示分支的实时 CI 指标。
