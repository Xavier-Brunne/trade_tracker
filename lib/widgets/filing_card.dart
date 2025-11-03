class FilingCard extends StatelessWidget {
  final SecFiling filing;
  final VoidCallback onSave;

  const FilingCard({required this.filing, required this.onSave, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(filing.title),
        subtitle: Text('Filed on ${filing.filingDate}'),
        trailing: IconButton(
          icon: const Icon(Icons.bookmark_add),
          onPressed: onSave,
        ),
      ),
    );
  }
}
