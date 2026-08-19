# 发布前检查清单

在将本仓库设置为 Public 前，逐项确认：

- [ ] `git status` 中只有计划公开的文件；
- [ ] 仓库从空目录创建，没有继承原工程的 `.git` 历史；
- [ ] 不包含 `vendor/`、`libs/`、`report/`、`output_data/`、`urgReport/`；
- [ ] 不包含 `.db`、`.sldb`、`.sdf`、`.spef`、`.ddc`、`.vdb`、`.fsdb`；
- [ ] 不包含简历、PPT、论文、原始日志、波形和业务输入；
- [ ] 不包含 token、密码、私钥、邮箱、电话、学号和内网地址；
- [ ] README 中的指标均有明确口径，没有把阶段性结果写成实时 CI 结果；
- [ ] `scripts/run_demo.ps1` 或 GitHub Actions 演示能够通过；
- [ ] 使用浏览器无痕窗口检查公开页面和 GitHub Actions；
- [ ] 如需展示更多代码，先在本仓库中独立重构，不从原工程整目录复制。

推荐仓库描述：

```text
Sanitized portfolio of a SystemC/RTL/UVM Mesh storage interconnect project.
```

推荐 Topics：

```text
systemc verilog systemverilog uvm noc mesh-interconnect rtl-design verification
```
