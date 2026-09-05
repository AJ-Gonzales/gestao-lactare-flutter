import 'package:flutter/material.dart';
import 'package:gestao_lactare/theme/app_colors.dart';

import '../../model/pesquisa_satisfacao.dart';
import '../../service/api_service.dart';
import '../../service/pesquisa_satisfacao_service.dart';

class AvaliacoesScreen extends StatefulWidget {
  const AvaliacoesScreen({super.key});

  @override
  State<AvaliacoesScreen> createState() => _AvaliacoesScreenState();
}

class _AvaliacoesScreenState extends State<AvaliacoesScreen> {
  final PesquisaSatisfacaoService service = PesquisaSatisfacaoService(
    ApiService(),
  );

  final TextEditingController dataController = TextEditingController();

  List<PesquisaSatisfacao> avaliacoes = [];
  List<PesquisaSatisfacao> avaliacoesFiltradas = [];

  bool carregando = true;
  String? erro;

  int? notaSelecionada;
  String periodoSelecionado = 'Todos';
  DateTime? dataSelecionada;
  bool somenteComComentario = false;

  @override
  void initState() {
    super.initState();
    _carregarAvaliacoes();
  }

  Future<void> _carregarAvaliacoes() async {
    try {
      final resultado = await service.buscarPesquisas();

      setState(() {
        avaliacoes = resultado;
        avaliacoesFiltradas = resultado;
        carregando = false;
      });
    } catch (e) {
      setState(() {
        erro = 'Erro ao carregar avaliações.';
        carregando = false;
      });
    }
  }

  void _pesquisar() {
    List<PesquisaSatisfacao> resultado = List.from(avaliacoes);

    // Filtro por nota
    if (notaSelecionada != null) {
      resultado = resultado
          .where((avaliacao) => avaliacao.nota == notaSelecionada)
          .toList();
    }

    final hoje = DateTime.now();

    if (periodoSelecionado == 'Últimos 7 dias') {
      final limite = hoje.subtract(const Duration(days: 7));

      resultado = resultado.where((avaliacao) {
        final data = DateTime.tryParse(avaliacao.dataResposta);

        if (data == null) return false;

        return !data.isBefore(limite) && !data.isAfter(hoje);
      }).toList();
    }

    if (periodoSelecionado == 'Últimos 30 dias') {
      final limite = hoje.subtract(const Duration(days: 30));

      resultado = resultado.where((avaliacao) {
        final data = DateTime.tryParse(avaliacao.dataResposta);

        if (data == null) return false;

        return !data.isBefore(limite) && !data.isAfter(hoje);
      }).toList();
    }

    if (dataSelecionada != null) {
      resultado = resultado.where((avaliacao) {
        final data = DateTime.tryParse(avaliacao.dataResposta);

        if (data == null) return false;

        return data.year == dataSelecionada!.year &&
            data.month == dataSelecionada!.month &&
            data.day == dataSelecionada!.day;
      }).toList();
    }

    if (somenteComComentario) {
      resultado = resultado.where((avaliacao) {
        return avaliacao.comentario != null &&
            avaliacao.comentario!.trim().isNotEmpty;
      }).toList();
    }

    setState(() {
      avaliacoesFiltradas = resultado;
    });
  }

  void _alterarSomenteComComentario(bool? valor) {
    setState(() {
      somenteComComentario = valor ?? false;
    });

    _pesquisar();
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: dataSelecionada ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (data != null) {
      setState(() {
        dataSelecionada = data;

        dataController.text =
            '${data.day.toString().padLeft(2, '0')}/'
            '${data.month.toString().padLeft(2, '0')}/'
            '${data.year}';
      });
    }
  }

  void _limparFiltros() {
    setState(() {
      notaSelecionada = null;
      periodoSelecionado = 'Todos';
      dataSelecionada = null;
      somenteComComentario = false;
      dataController.clear();

      avaliacoesFiltradas = avaliacoes;
    });
  }

  @override
  void dispose() {
    dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Avaliações')),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Consultar avaliações',
              style: TextStyle(fontSize: 28, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 24),

            _FiltrosAvaliacoes(
              notaSelecionada: notaSelecionada,
              periodoSelecionado: periodoSelecionado,
              dataController: dataController,
              somenteComComentario: somenteComComentario,
              onNotaChanged: (valor) {
                setState(() {
                  notaSelecionada = valor;
                });
              },
              onPeriodoChanged: (valor) {
                setState(() {
                  periodoSelecionado = valor;
                });
              },
              onSelecionarData: _selecionarData,
              onComentarioChanged: _alterarSomenteComComentario,
              onPesquisar: _pesquisar,
              onLimpar: _limparFiltros,
            ),

            const SizedBox(height: 24),

            Expanded(child: _buildConteudo()),
          ],
        ),
      ),
    );
  }

  Widget _buildConteudo() {
    if (carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (erro != null) {
      return Center(
        child: Text(
          erro!,
          style: const TextStyle(color: AppColors.error, fontSize: 16),
        ),
      );
    }

    if (avaliacoesFiltradas.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma avaliação encontrada.',
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 420,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.55,
      ),
      itemCount: avaliacoesFiltradas.length,
      itemBuilder: (context, index) {
        final avaliacao = avaliacoesFiltradas[index];

        return _AvaliacaoCard(avaliacao: avaliacao);
      },
    );
  }
}

class _FiltrosAvaliacoes extends StatelessWidget {
  final int? notaSelecionada;
  final String periodoSelecionado;
  final TextEditingController dataController;
  final bool somenteComComentario;

  final ValueChanged<int?> onNotaChanged;
  final ValueChanged<String> onPeriodoChanged;
  final VoidCallback onSelecionarData;
  final ValueChanged<bool?> onComentarioChanged;
  final VoidCallback onPesquisar;
  final VoidCallback onLimpar;

  const _FiltrosAvaliacoes({
    required this.notaSelecionada,
    required this.periodoSelecionado,
    required this.dataController,
    required this.somenteComComentario,
    required this.onNotaChanged,
    required this.onPeriodoChanged,
    required this.onSelecionarData,
    required this.onComentarioChanged,
    required this.onPesquisar,
    required this.onLimpar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 180,
              child: DropdownButtonFormField<int?>(
                value: notaSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Nota',
                  prefixIcon: Icon(Icons.star_outline),
                ),
                items: const [
                  DropdownMenuItem<int?>(value: null, child: Text('Todas')),
                  DropdownMenuItem<int?>(value: 1, child: Text('1 estrela')),
                  DropdownMenuItem<int?>(value: 2, child: Text('2 estrelas')),
                  DropdownMenuItem<int?>(value: 3, child: Text('3 estrelas')),
                  DropdownMenuItem<int?>(value: 4, child: Text('4 estrelas')),
                  DropdownMenuItem<int?>(value: 5, child: Text('5 estrelas')),
                ],
                onChanged: onNotaChanged,
              ),
            ),

            SizedBox(
              width: 200,
              child: DropdownButtonFormField<String>(
                value: periodoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Período',
                  prefixIcon: Icon(Icons.date_range_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'Todos', child: Text('Todos')),
                  DropdownMenuItem(
                    value: 'Últimos 7 dias',
                    child: Text('Últimos 7 dias'),
                  ),
                  DropdownMenuItem(
                    value: 'Últimos 30 dias',
                    child: Text('Últimos 30 dias'),
                  ),
                ],
                onChanged: (valor) {
                  if (valor != null) {
                    onPeriodoChanged(valor);
                  }
                },
              ),
            ),

            SizedBox(
              width: 180,
              child: TextField(
                controller: dataController,
                readOnly: true,
                onTap: onSelecionarData,
                decoration: const InputDecoration(
                  labelText: 'Data',
                  hintText: 'Selecionar data',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: somenteComComentario,
                  onChanged: onComentarioChanged,
                ),
                const Text('Somente com comentário'),
              ],
            ),

            ElevatedButton.icon(
              onPressed: onPesquisar,
              icon: const Icon(Icons.search),
              label: const Text('Pesquisar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
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

class _AvaliacaoCard extends StatelessWidget {
  final PesquisaSatisfacao avaliacao;

  const _AvaliacaoCard({required this.avaliacao});

  @override
  Widget build(BuildContext context) {
    final data = DateTime.tryParse(avaliacao.dataResposta);

    final dataFormatada = data != null
        ? '${data.day.toString().padLeft(2, '0')}/'
              '${data.month.toString().padLeft(2, '0')}/'
              '${data.year}'
        : avaliacao.dataResposta;

    final temComentario =
        avaliacao.comentario != null && avaliacao.comentario!.trim().isNotEmpty;

    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person_outline, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Nutriz #${avaliacao.nutrizId}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  dataFormatada,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                const Text(
                  'Nota: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                ...List.generate(
                  5,
                  (index) => Icon(
                    index < avaliacao.nota ? Icons.star : Icons.star_border,
                    size: 20,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (temComentario) ...[
              const Text(
                'Comentário',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  avaliacao.comentario!,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ),
            ] else
              const Text(
                'Sem comentário.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
