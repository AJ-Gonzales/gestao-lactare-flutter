import 'package:flutter/material.dart';
import 'package:gestao_lactare/theme/app_colors.dart';

import '../../model/doacao.dart';
import '../../service/api_service.dart';
import '../../service/doacao_service.dart';

class DoacoesScreen extends StatefulWidget {
  const DoacoesScreen({super.key});

  @override
  State<DoacoesScreen> createState() => _DoacoesScreenState();
}

class _DoacoesScreenState extends State<DoacoesScreen> {
  final DoacaoService service = DoacaoService(ApiService());

  List<Doacao> doacoes = [];
  List<Doacao> doacoesFiltradas = [];

  bool carregando = true;
  String? erro;

  String? periodoSelecionado;
  DateTime? dataSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarDoacoes();
  }

  Future<void> _carregarDoacoes() async {
    try {
      final dados = await service.buscarDoacoes();

      setState(() {
        doacoes = dados;
        doacoesFiltradas = dados;
        carregando = false;
      });
    } catch (e) {
      setState(() {
        erro = e.toString();
        carregando = false;
      });
    }
  }

  void _pesquisar() {
    final hoje = DateTime.now();

    setState(() {
      doacoesFiltradas = doacoes.where((doacao) {
        final dataDoacao = DateTime.tryParse(doacao.data);

        if (dataDoacao == null) {
          return false;
        }

        bool correspondePeriodo = true;
        bool correspondeData = true;

        if (periodoSelecionado == '7 dias') {
          final limite = hoje.subtract(const Duration(days: 7));

          correspondePeriodo =
              !dataDoacao.isBefore(limite) && !dataDoacao.isAfter(hoje);
        }

        if (periodoSelecionado == '30 dias') {
          final limite = hoje.subtract(const Duration(days: 30));

          correspondePeriodo =
              !dataDoacao.isBefore(limite) && !dataDoacao.isAfter(hoje);
        }

        if (dataSelecionada != null) {
          correspondeData =
              dataDoacao.year == dataSelecionada!.year &&
              dataDoacao.month == dataSelecionada!.month &&
              dataDoacao.day == dataSelecionada!.day;
        }

        return correspondePeriodo && correspondeData;
      }).toList();
    });
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();

    final data = await showDatePicker(
      context: context,
      initialDate: dataSelecionada ?? hoje,
      firstDate: DateTime(2020),
      lastDate: hoje,
    );

    if (data != null) {
      setState(() {
        dataSelecionada = data;
      });
    }
  }

  void _limparFiltros() {
    setState(() {
      periodoSelecionado = null;
      dataSelecionada = null;
      doacoesFiltradas = doacoes;
    });
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doações')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acompanhe as doações realizadas.',
              style: TextStyle(fontSize: 28, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 24),

            _FiltrosDoacoes(
              periodoSelecionado: periodoSelecionado,
              dataSelecionada: dataSelecionada,
              onPeriodoChanged: (valor) {
                periodoSelecionado = valor;
              },
              onSelecionarData: _selecionarData,
              onPesquisar: _pesquisar,
              onLimpar: _limparFiltros,
              formatarData: _formatarData,
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
      return Center(child: Text('Erro ao carregar doações: $erro'));
    }

    if (doacoesFiltradas.isEmpty) {
      return const Center(child: Text('Nenhuma doação encontrada.'));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 380,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.7,
      ),
      itemCount: doacoesFiltradas.length,
      itemBuilder: (context, index) {
        return _DoacaoCard(doacao: doacoesFiltradas[index]);
      },
    );
  }
}

class _FiltrosDoacoes extends StatelessWidget {
  final String? periodoSelecionado;
  final DateTime? dataSelecionada;

  final ValueChanged<String?> onPeriodoChanged;
  final VoidCallback onSelecionarData;
  final VoidCallback onPesquisar;
  final VoidCallback onLimpar;

  final String Function(DateTime) formatarData;

  const _FiltrosDoacoes({
    required this.periodoSelecionado,
    required this.dataSelecionada,
    required this.onPeriodoChanged,
    required this.onSelecionarData,
    required this.onPesquisar,
    required this.onLimpar,
    required this.formatarData,
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
                  prefixIcon: Icon(Icons.date_range_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Todos')),
                  DropdownMenuItem(
                    value: '7 dias',
                    child: Text('Últimos 7 dias'),
                  ),
                  DropdownMenuItem(
                    value: '30 dias',
                    child: Text('Últimos 30 dias'),
                  ),
                ],
                onChanged: onPeriodoChanged,
              ),
            ),

            SizedBox(
              width: 220,
              child: InkWell(
                onTap: onSelecionarData,
                borderRadius: BorderRadius.circular(8),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    dataSelecionada == null
                        ? 'Todas'
                        : formatarData(dataSelecionada!),
                  ),
                ),
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

class _DoacaoCard extends StatelessWidget {
  final Doacao doacao;

  const _DoacaoCard({required this.doacao});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doação #${doacao.id}',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            _InfoLinha(
              icone: Icons.calendar_today_outlined,
              texto: doacao.data,
            ),

            const SizedBox(height: 8),

            _InfoLinha(
              icone: Icons.water_drop_outlined,
              texto: '${doacao.quantidade} ml',
            ),

            const SizedBox(height: 8),

            _InfoLinha(
              icone: Icons.person_outline,
              texto: 'Nutriz #${doacao.nutrizId}',
            ),

            const SizedBox(height: 8),

            _InfoLinha(
              icone: Icons.local_hospital_outlined,
              texto: 'Banco de leite #${doacao.bancoLeiteId}',
            ),

            const SizedBox(height: 8),

            _InfoLinha(
              icone: Icons.event_outlined,
              texto: 'Agendamento #${doacao.agendamentoId}',
            ),
          ],
        ),
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
