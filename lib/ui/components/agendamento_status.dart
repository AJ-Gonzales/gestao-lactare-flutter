import 'package:flutter/material.dart';

class AgendamentoStatus extends StatelessWidget {
  final int confirmados;
  final int pendentes;
  final int cancelados;

  const AgendamentoStatus({
    super.key,
    required this.confirmados,
    required this.pendentes,
    required this.cancelados,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Agendamentos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            _StatusItem(
              icone: Icons.check_circle_outline,
              texto: 'Confirmados',
              quantidade: confirmados,
            ),

            const SizedBox(height: 14),

            _StatusItem(
              icone: Icons.schedule,
              texto: 'Pendentes',
              quantidade: pendentes,
            ),

            const SizedBox(height: 14),

            _StatusItem(
              icone: Icons.cancel_outlined,
              texto: 'Cancelados',
              quantidade: cancelados,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icone;
  final String texto;
  final int quantidade;

  const _StatusItem({
    required this.icone,
    required this.texto,
    required this.quantidade,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icone, size: 20),

        const SizedBox(width: 10),

        Expanded(child: Text(texto)),

        Text(
          quantidade.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}