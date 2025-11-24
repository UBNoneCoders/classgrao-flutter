import 'package:classgrao/src/core/widgets/app_loading.dart';
import 'package:classgrao/src/data/models/audit_model.dart';
import 'package:classgrao/src/data/services/audit/audit_service.dart';
import 'package:classgrao/src/ui/audit/audit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AuditPage extends ConsumerStatefulWidget {
  const AuditPage({super.key});

  @override
  ConsumerState<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends ConsumerState<AuditPage> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final auditLogsAsync = ref.watch(auditViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auditoria do Sistema'),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Row(
                  children: [
                    Icon(Icons.all_inclusive, size: 20),
                    SizedBox(width: 8),
                    Text('Todos'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'auth',
                child: Row(
                  children: [
                    Icon(Icons.login, size: 20),
                    SizedBox(width: 8),
                    Text('Autenticação'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'user',
                child: Row(
                  children: [
                    Icon(Icons.person, size: 20),
                    SizedBox(width: 8),
                    Text('Usuários'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'classification',
                child: Row(
                  children: [
                    Icon(Icons.analytics, size: 20),
                    SizedBox(width: 8),
                    Text('Classificações'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: auditLogsAsync.when(
        data: (logs) => _buildAuditList(context, logs),
        loading: () => const AppLoading(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(auditViewModelProvider.notifier).refresh();
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuditList(BuildContext context, List<AuditLogModel> logs) {
    // Aplica filtro
    List<AuditLogModel> filteredLogs = logs;
    if (_selectedFilter != 'all') {
      filteredLogs = ref
          .read(auditServiceProvider)
          .filterByCategory(logs, _selectedFilter);
    }

    // Ordena por data decrescente (mais recente primeiro)
    filteredLogs.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Agrupa por data
    final groupedLogs = ref
        .read(auditServiceProvider)
        .groupByDate(filteredLogs);
    final sortedDates = groupedLogs.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('dd/MM/yyyy').parse(a);
        final dateB = DateFormat('dd/MM/yyyy').parse(b);
        return dateB.compareTo(dateA);
      });

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(auditViewModelProvider.notifier).refresh();
      },
      child: filteredLogs.isEmpty
          ? const Center(
              child: Text('Nenhum log de auditoria encontrado'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedDates.length,
              itemBuilder: (context, index) {
                final date = sortedDates[index];
                final logsForDate = groupedLogs[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      child: Text(
                        date,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00695C),
                        ),
                      ),
                    ),
                    ...logsForDate.map((log) => _buildAuditCard(log)),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildAuditCard(AuditLogModel log) {
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => _showLogDetails(log),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildActionIcon(log),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            log.actionType,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          timeFormat.format(log.createdAt),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      log.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            log.userName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (log.ipAddress != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'IP: ${log.ipAddress}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcon(AuditLogModel log) {
    IconData icon;
    Color color;

    switch (log.actionCategory) {
      case 'auth':
        icon = log.isSuccess ? Icons.login : Icons.lock_outline;
        color = log.isSuccess ? Colors.green : Colors.orange;
        break;
      case 'classification':
        icon = Icons.analytics;
        color = Colors.blue;
        break;
      case 'user':
        if (log.action.contains('DELETE')) {
          icon = Icons.person_remove;
          color = Colors.red;
        } else if (log.action.contains('CREATE')) {
          icon = Icons.person_add;
          color = Colors.green;
        } else if (log.action.contains('DEACTIVATE')) {
          icon = Icons.block;
          color = Colors.orange;
        } else if (log.action.contains('ACTIVATE')) {
          icon = Icons.check_circle;
          color = Colors.green;
        } else {
          icon = Icons.edit;
          color = Colors.blue;
        }
        break;
      default:
        icon = Icons.info_outline;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  void _showLogDetails(AuditLogModel log) {
    final dateFormat = DateFormat('dd/MM/yyyy às HH:mm:ss');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(log.actionType),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('ID', log.id.toString()),
              _buildDetailRow('Usuário', log.userName),
              if (log.user != null) ...[
                _buildDetailRow('Username', log.user!.username),
                _buildDetailRow('Perfil', log.user!.role),
              ],
              _buildDetailRow('Ação', log.action),
              _buildDetailRow('Descrição', log.description),
              if (log.ipAddress != null)
                _buildDetailRow('Endereço IP', log.ipAddress!),
              _buildDetailRow('Data/Hora', dateFormat.format(log.createdAt)),
              if (log.details.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Detalhes:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    log.details.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
