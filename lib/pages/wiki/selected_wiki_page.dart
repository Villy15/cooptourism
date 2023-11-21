import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/data/models/wiki.dart';
import 'package:cooptourism/data/repositories/wiki_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

final WikiRepository wikiRepository = WikiRepository();

class SelectedWikiPage extends ConsumerStatefulWidget {
  final String wikiId;
  const SelectedWikiPage({Key? key, required this.wikiId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectedWikiPageState();
}

class _SelectedWikiPageState extends ConsumerState<SelectedWikiPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _updateNavBarAndAppBarVisibility(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Future<WikiModel?> wiki =
        wikiRepository.getSpecificWiki(widget.wikiId);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        _updateNavBarAndAppBarVisibility(true);
        return true;
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: FutureBuilder<WikiModel?>(
            future: wiki,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final wiki = snapshot.data!;

              return _buildBody(wiki);
            }),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Wiki Page',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {
          _updateNavBarAndAppBarVisibility(true);
          Navigator.of(context).pop(); // to go back
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {
            // context.go('/wiki_page/${widget.wikiId}/edit');
          },
        ),
      ],
    );
  }

  Widget _buildBody(WikiModel wiki) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add an image placeholder
          const SizedBox(height: 200, child: Placeholder()),
          const SizedBox(height: 20),

          titleWikiPost(wiki),

          const SizedBox(height: 20),

          contentWikiPost(wiki),
        ],
      ),
    );
  }

  Text contentWikiPost(WikiModel wiki) {
    return Text(
      wiki.description ?? 'No content',
      style: const TextStyle(fontSize: 16),
    );
  }

  Row titleWikiPost(WikiModel wiki) {
    return Row(
      children: [
        Expanded(
            child: Text(wiki.title ?? 'No title',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold))),
        // Wrap the icon button to a square container with smooth edges
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            icon: const Icon(
                Icons.favorite), // Use Icons.favorite for a filled heart
            onPressed: () {
              // Add your favorite functionality here
            },
          ),
        ),
      ],
    );
  }

  void _updateNavBarAndAppBarVisibility(bool isVisible) {
    ref.read(navBarVisibilityProvider.notifier).state = isVisible;
    ref.read(appBarVisibilityProvider.notifier).state = isVisible;
  }
}
