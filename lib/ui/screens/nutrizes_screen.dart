import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestao_lactare/theme/app_colors.dart';

import '../../model/nutriz.dart';
import '../../service/api_service.dart';
import '../../service/nutriz_service.dart';

class NutrizesScreen extends StatefulWidget {
  const NutrizesScreen({super.key});

  @override
  State<NutrizesScreen> createState() => _NutrizesScreenState();
}

class _NutrizesScreenState extends State<NutrizesScreen> {
  final NutrizService service = NutrizService(ApiService());

  final TextEditingController buscaController = TextEditingController();

  final TextEditingController cpfController = TextEditingController();

  List<Nutriz> nutrizes = [];
  List<Nutriz> nutrizesFiltradas = [];

  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    _carregarNutrizes();
  }

  Future<void> _carregarNutrizes() async {
    try {
      final resultado = await service.buscarNutrizes();

      if (!mounted) return;

      setState(() {
        nutrizes = resultado;
        nutrizesFiltradas = resultado;
        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        erro = e.toString();
        carregando = false;
      });
    }
  }

  void _pesquisar() {
    final busca = buscaController.text.toLowerCase().trim();
    final cpf = cpfController.text.trim();

    setState(() {
      nutrizesFiltradas = nutrizes.where((nutriz) {
        final correspondeBusca =
            busca.isEmpty ||
            nutriz.nome.toLowerCase().contains(busca);

        final correspondeCpf = cpf.isEmpty || nutriz.cpf.contains(cpf);

        return correspondeBusca && correspondeCpf;
      }).toList();
    });
  }

  void _limparFiltros() {
    buscaController.clear();
    cpfController.clear();

    setState(() {
      nutrizesFiltradas = nutrizes;
    });
  }

  @override
  void dispose() {
    buscaController.dispose();
    cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (erro != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nutrizes')),
        body: Center(child: Text('Erro ao carregar nutrizes: $erro')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nutrizes')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nutrizes cadastradas no sistema.',
              style: TextStyle(fontSize: 28, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 24),

            _FiltrosNutrizes(
              buscaController: buscaController,
              cpfController: cpfController,
              onPesquisar: _pesquisar,
              onLimpar: _limparFiltros,
            ),

            const SizedBox(height: 20),

            Text(
              '${nutrizesFiltradas.length} '
              '${nutrizesFiltradas.length == 1 ? 'nutriz encontrada' : 'nutrizes encontradas'}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: nutrizesFiltradas.isEmpty
                  ? const Center(
                      child: Text('Nenhuma nutriz corresponde aos filtros.'),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 380,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.7,
                          ),
                      itemCount: nutrizesFiltradas.length,
                      itemBuilder: (context, index) {
                        return _NutrizCard(nutriz: nutrizesFiltradas[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltrosNutrizes extends StatelessWidget {
  final TextEditingController buscaController;
  final TextEditingController cpfController;
  final VoidCallback onPesquisar;
  final VoidCallback onLimpar;

  const _FiltrosNutrizes({
    required this.buscaController,
    required this.cpfController,
    required this.onPesquisar,
    required this.onLimpar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: buscaController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => onPesquisar(),
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  hintText: 'Pesquisar nutriz...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              flex: 1,
              child: TextField(
                controller: cpfController,
                textInputAction: TextInputAction.search,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                onSubmitted: (_) => onPesquisar(),
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  hintText: 'Pesquisar por CPF...',
                  prefixIcon: Icon(Icons.person_pin),
                ),
              ),
            ),

            const SizedBox(width: 16),

            ElevatedButton.icon(
              onPressed: onPesquisar,
              icon: const Icon(Icons.search),
              label: const Text('Pesquisar'),
            ),

            const SizedBox(width: 8),

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

class _NutrizCard extends StatelessWidget {
  final Nutriz nutriz;

  const _NutrizCard({required this.nutriz});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.person_outline,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    nutriz.nome,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            _InfoLinha(icone: Icons.phone_outlined, texto: nutriz.telefone),

            const SizedBox(height: 8),

            _InfoLinha(
              icone: Icons.email_outlined,
              texto: nutriz.email ?? 'E-mail não informado',
            ),

            const SizedBox(height: 8),

            _InfoLinha(
              icone: Icons.person_pin,
              texto: 'CPF: ${nutriz.cpf}',
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
        Icon(icone, size: 18, color: AppColors.secondary),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            texto,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
