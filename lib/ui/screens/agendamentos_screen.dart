import 'package:flutter/material.dart';
import 'package:gestao_lactare/theme/app_colors.dart';

import '../../model/agendamento.dart';
import '../../service/api_service.dart';
import '../../service/agendamento_service.dart';

class AgendamentosScreen extends StatefulWidget {
  const AgendamentosScreen({super.key});

  @override
  State<AgendamentosScreen> createState() => _AgendamentosScreenState();
}

class _AgendamentosScreenState extends State<AgendamentosScreen> {
  final AgendamentoService service = AgendamentoService(ApiService());

  List<Agendamento> agendamentos = [];
  List<Agendamento> agendamentosFiltrados = [];

  bool carregando = true;
  String? erro;

  String? periodoSelecionado;
  String? mesSelecionado;
  String? statusSelecionado;

  @override
  void initState() {
    super.initState();
    _carregarAgendamentos();
  }

  Future<void> _carregarAgendamentos() async {
    try {
      final dados = await service.buscarAgendamentos();

      setState(() {
        agendamentos = dados;
        agendamentosFiltrados = dados;
        carregando = false;
        erro = null;
      });
    } catch (e) {
      setState(() {
        erro = e.toString();
        carregando = false;
      });
    }
  }

  void _pesquisar() {
    setState(() {
      agendamentosFiltrados = agendamentos.where((agendamento) {
        final correspondeMes = _filtrarPorMes(agendamento);

        final correspondePeriodo = _filtrarPorPeriodo(agendamento);

        final correspondeStatus =
            statusSelecionado == null ||
            agendamento.status.toLowerCase() ==
                statusSelecionado!.toLowerCase();

        return correspondeMes && correspondePeriodo && correspondeStatus;
      }).toList();
    });
  }

  bool _filtrarPorMes(Agendamento agendamento) {
    if (mesSelecionado == null) {
      return true;
    }

    final data = agendamento.data;

    if (data.length < 7) {
      return false;
    }

    final mes = data.substring(5, 7);

    return mes == mesSelecionado;
  }

  bool _filtrarPorPeriodo(Agendamento agendamento) {
    if (periodoSelecionado == null) {
      return true;
    }

    final horario = agendamento.horario;

    if (horario.length < 2) {
      return false;
    }

    final hora = int.tryParse(horario.substring(0, 2));

    if (hora == null) {
      return false;
    }

    switch (periodoSelecionado) {
      case 'Manhã':
        return hora >= 6 && hora < 12;

      case 'Tarde':
        return hora >= 12 && hora < 18;

      case 'Noite':
        return hora >= 18 && hora < 24;

      default:
        return true;
    }
  }

  void _limparFiltros() {
    setState(() {
      periodoSelecionado = null;
      mesSelecionado = null;
      statusSelecionado = null;
      agendamentosFiltrados = agendamentos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agendamentos')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acompanhe os agendamentos realizados.',
              style: TextStyle(fontSize: 28, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 24),

            _FiltrosAgendamentos(
              periodoSelecionado: periodoSelecionado,
              mesSelecionado: mesSelecionado,
              statusSelecionado: statusSelecionado,

              onPeriodoChanged: (valor) {
                setState(() {
                  periodoSelecionado = valor;
                });
              },

              onMesChanged: (valor) {
                setState(() {
                  mesSelecionado = valor;
                });
              },

              onStatusChanged: (valor) {
                setState(() {
                  statusSelecionado = valor;
                });
              },

              onPesquisar: _pesquisar,
              onLimpar: _limparFiltros,
            ),

            const SizedBox(height: 24),

            Expanded(child: _conteudo()),
          ],
        ),
      ),
    );
  }

  Widget _conteudo() {
    if (carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (erro != null) {
      return Center(child: Text('Erro ao carregar agendamentos: $erro'));
    }

    if (agendamentosFiltrados.isEmpty) {
      return const Center(child: Text('Nenhum agendamento encontrado.'));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 380,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 310,
      ),
      itemCount: agendamentosFiltrados.length,
      itemBuilder: (context, index) {
        final agendamento = agendamentosFiltrados[index];

        return _AgendamentoCard(
          agendamento: agendamento,
          onStatusAlterado: _carregarAgendamentos,
        );
      },
    );
  }
}

class _FiltrosAgendamentos extends StatelessWidget {
  final String? periodoSelecionado;
  final String? mesSelecionado;
  final String? statusSelecionado;

  final ValueChanged<String?> onPeriodoChanged;
  final ValueChanged<String?> onMesChanged;
  final ValueChanged<String?> onStatusChanged;

  final VoidCallback onPesquisar;
  final VoidCallback onLimpar;

  const _FiltrosAgendamentos({
    required this.periodoSelecionado,
    required this.mesSelecionado,
    required this.statusSelecionado,
    required this.onPeriodoChanged,
    required this.onMesChanged,
    required this.onStatusChanged,
    required this.onPesquisar,
    required this.onLimpar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: DropdownButtonFormField<String>(
                value: periodoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Período',
                  prefixIcon: Icon(Icons.access_time_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Todos')),
                  DropdownMenuItem(value: 'Manhã', child: Text('Manhã')),
                  DropdownMenuItem(value: 'Tarde', child: Text('Tarde')),
                  DropdownMenuItem(value: 'Noite', child: Text('Noite')),
                ],
                onChanged: onPeriodoChanged,
              ),
            ),

            SizedBox(
              width: 200,
              child: DropdownButtonFormField<String>(
                value: mesSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Mês',
                  prefixIcon: Icon(Icons.calendar_month_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Todos')),
                  DropdownMenuItem(value: '01', child: Text('Janeiro')),
                  DropdownMenuItem(value: '02', child: Text('Fevereiro')),
                  DropdownMenuItem(value: '03', child: Text('Março')),
                  DropdownMenuItem(value: '04', child: Text('Abril')),
                  DropdownMenuItem(value: '05', child: Text('Maio')),
                  DropdownMenuItem(value: '06', child: Text('Junho')),
                  DropdownMenuItem(value: '07', child: Text('Julho')),
                  DropdownMenuItem(value: '08', child: Text('Agosto')),
                  DropdownMenuItem(value: '09', child: Text('Setembro')),
                  DropdownMenuItem(value: '10', child: Text('Outubro')),
                  DropdownMenuItem(value: '11', child: Text('Novembro')),
                  DropdownMenuItem(value: '12', child: Text('Dezembro')),
                ],
                onChanged: onMesChanged,
              ),
            ),

            SizedBox(
              width: 220,
              child: DropdownButtonFormField<String>(
                value: statusSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  prefixIcon: Icon(Icons.event_available_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Todos')),
                  DropdownMenuItem(
                    value: 'Confirmado',
                    child: Text('Confirmado'),
                  ),
                  DropdownMenuItem(value: 'Pendente', child: Text('Pendente')),
                  DropdownMenuItem(
                    value: 'Cancelado',
                    child: Text('Cancelado'),
                  ),
                  DropdownMenuItem(
                    value: 'Concluido',
                    child: Text('Concluído'),
                  ),
                  DropdownMenuItem(
                    value: 'Nao_compareceu',
                    child: Text('Não compareceu'),
                  ),
                ],
                onChanged: onStatusChanged,
              ),
            ),

            ElevatedButton.icon(
              onPressed: onPesquisar,
              icon: const Icon(Icons.search),
              label: const Text('Pesquisar'),
            ),

            OutlinedButton.icon(
              onPressed: onLimpar,
              icon: const Icon(Icons.clear),
              label: const Text('Limpar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AgendamentoCard extends StatefulWidget {
  final Agendamento agendamento;
  final VoidCallback onStatusAlterado;

  const _AgendamentoCard({
    required this.agendamento,
    required this.onStatusAlterado,
  });

  @override
  State<_AgendamentoCard> createState() => _AgendamentoCardState();
}

class _AgendamentoCardState extends State<_AgendamentoCard> {
  final AgendamentoService service = AgendamentoService(ApiService());

  bool atualizando = false;

  Future<void> _alterarStatus(String novoStatus) async {
    setState(() {
      atualizando = true;
    });

    try {
      await service.atualizarStatus(widget.agendamento.id, novoStatus);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status atualizado com sucesso!')),
      );

      widget.onStatusAlterado();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar status: $e')));
    } finally {
      if (mounted) {
        setState(() {
          atualizando = false;
        });
      }
    }
  }

  void _mostrarOpcoesStatus() {
    final status = widget.agendamento.status.toLowerCase();

    List<String> opcoes = [];

    if (status == 'pendente') {
      opcoes = ['CONFIRMADO', 'CANCELADO'];
    } else if (status == 'confirmado') {
      opcoes = ['CONCLUIDO', 'NAO_COMPARECEU', 'CANCELADO'];
    }

    if (opcoes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Este agendamento já foi finalizado e não pode ter o status alterado.',
          ),
        ),
      );

      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Alterar status do agendamento #${widget.agendamento.id}',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: opcoes.map((status) {
              return ListTile(
                leading: const Icon(Icons.sync_alt),
                title: Text(_nomeStatus(status)),
                onTap: () {
                  Navigator.pop(context);
                  _alterarStatus(status);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _nomeStatus(String status) {
    switch (status) {
      case 'CONFIRMADO':
        return 'Confirmado';

      case 'CANCELADO':
        return 'Cancelado';

      case 'CONCLUIDO':
        return 'Concluído';

      case 'NAO_COMPARECEU':
        return 'Não compareceu';

      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Agendamento #${widget.agendamento.id}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                _StatusBadge(status: widget.agendamento.status),
              ],
            ),

            const SizedBox(height: 16),

            _InfoLinha(
              icone: Icons.calendar_today_outlined,
              texto: widget.agendamento.data,
            ),

            const SizedBox(height: 8),

            _InfoLinha(
              icone: Icons.access_time_outlined,
              texto: widget.agendamento.horario,
            ),

            const SizedBox(height: 8),

            _InfoLinha(
              icone: Icons.person_outline,
              texto: 'Nutriz #${widget.agendamento.nutrizId}',
            ),

            const SizedBox(height: 8),

            _InfoLinha(
              icone: Icons.local_hospital_outlined,
              texto: 'Banco de leite #${widget.agendamento.bancoLeiteId}',
            ),

            const Spacer(),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: atualizando ? null : _mostrarOpcoesStatus,
                icon: atualizando
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.edit_outlined),
                label: Text(atualizando ? 'Atualizando...' : 'Alterar status'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color cor;

    switch (status.toLowerCase()) {
      case 'confirmado':
        cor = AppColors.success;
        break;

      case 'cancelado':
        cor = AppColors.error;
        break;

      case 'concluido':
        cor = AppColors.primary;
        break;

      case 'nao_compareceu':
        cor = AppColors.error;
        break;

      default:
        cor = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: cor, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}

class _InfoLinha extends StatelessWidget {
  final IconData icone;
  final String texto;

  const _InfoLinha({required this.icone, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icone, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(texto)),
      ],
    );
  }
}
