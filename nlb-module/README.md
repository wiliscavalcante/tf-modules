Aqui está o conteúdo do arquivo README.md com o código fornecido:

```markdown
# Network Load Balancer (NLB) Internal Module

Este módulo do Terraform cria um Network Load Balancer (NLB) interno na AWS. O NLB interno é um balanceador de carga de rede usado para distribuir o tráfego de entrada para vários destinos dentro da VPC.

## Uso

```hcl
module "nlb_internal" {
  source = "caminho/para/o/modulo"

  name                          = "meu-nlb-interno"
  subnet_ids                    = ["subnet-xxxxxx", "subnet-xxxxxx"]
  enable_cross_zone_load_balancing = true
  listener_port                 = 443
  listener_protocol             = "TCP"
  target_group_name             = "meu-target-group"
  target_group_port             = 443
  target_group_protocol         = "TCP"
  vpc_id                        = "vpc-xxxxxx"
  target_id                     = "i-xxxxxx"
  tags                          = {
    Name        = "nlb-interno"
    Environment = "production"
  }
}
```

## Requisitos

- Terraform versão 0.14 ou superior
- Conta na AWS com permissões para criar recursos do NLB interno

## Entradas

| Nome                            | Descrição                                     | Tipo             | Padrão   | Obrigatório |
| ------------------------------- | --------------------------------------------- | ----------------- | -------- | ----------- |
| `name`                          | Nome do NLB interno                           | `string`         | -        | Sim         |
| `subnet_ids`                    | Lista de IDs das subnets                       | `list(string)`   | -        | Sim         |
| `enable_cross_zone_load_balancing` | Habilita o balanceamento de carga entre zonas | `bool`           | `false`  | Não         |
| `listener_port`                 | Porta para o listener                          | `number`         | -        | Sim         |
| `listener_protocol`             | Protocolo para o listener                      | `string`         | -        | Sim         |
| `target_group_name`             | Nome do target group                           | `string`         | -        | Sim         |
| `target_group_port`             | Porta para o target group                      | `number`         | -        | Sim         |
| `target_group_protocol`         | Protocolo para o target group                  | `string`         | -        | Sim         |
| `vpc_id`                        | ID da VPC                                     | `string`         | -        | Sim         |
| `target_id`                     | ID do target                                   | `string`         | -        | Sim         |
| `target_type`                   | Tipo de target                                 | `string`         | `ip`     | Não         |
| `tags`                          | Tags para os recursos                          | `map(string)`    | `{}`     | Não         |

## Saídas

| Nome                            | Descrição                                     |
| ------------------------------- | --------------------------------------------- |
| `dns_name`                      | Nome DNS do NLB interno                        |


```

Certifique-se de substituir `"caminho/para/o/modulo"` no exemplo de uso pelo caminho correto do módulo no seu sistema.
