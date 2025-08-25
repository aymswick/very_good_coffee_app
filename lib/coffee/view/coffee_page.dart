import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_api/coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:very_good_coffee/app/shared/snackbars.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_bloc.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

const batchSize = 10;

class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: PlatformCircularProgressIndicator(),
      ),
    );
  }
}

class CoffeeItem extends StatelessWidget {
  const CoffeeItem({required this.coffee, super.key});

  final Coffee coffee;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<CoffeeBloc>();

    final cachedCoffeeImage = CachedNetworkImage(
      cacheKey: coffee.name,
      imageUrl: coffee.url.toString(),
      errorWidget: (context, url, error) => const Padding(
        padding: EdgeInsets.all(32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Icon(Icons.sentiment_dissatisfied),
            Text("Couldn't fetch image."),
          ],
        ),
      ),
      progressIndicatorBuilder: (context, url, progress) => const SizedBox(
        height: 24,
        width: 24,
        child: PlatformCircularProgressIndicator(),
      ),
      fit: BoxFit.fill,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Center(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: cachedCoffeeImage,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      coffee.name,
                      style: theme.textTheme.labelLarge,
                    ),
                    PlatformIconButton(
                      key: const Key('download_coffee_btn'),
                      padding: const EdgeInsets.all(8),
                      onPressed: () => bloc.add(
                        CoffeeDownloaded(
                          coffee: coffee,
                          cacheKey: cachedCoffeeImage.cacheKey!,
                          cacheManager: DefaultCacheManager(),
                        ),
                      ),
                      icon: Icon(
                        Icons.download,
                        color: bloc.state.downloads.contains(coffee)
                            ? Colors.blue
                            : theme.colorScheme.inverseSurface,
                      ),
                    ),
                    PlatformIconButton(
                      key: const Key('favorite_coffee_btn'),
                      padding: const EdgeInsets.all(8),
                      onPressed: () => bloc.add(CoffeeFavorited(coffee)),
                      icon: Icon(
                        Icons.favorite,
                        color: bloc.state.favorites.contains(coffee)
                            ? theme.colorScheme.primary
                            : theme.colorScheme.inverseSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CoffeeList extends StatefulWidget {
  const CoffeeList({
    super.key,
  });

  @override
  State<CoffeeList> createState() => _CoffeeListState();
}

class CoffeePage extends StatelessWidget {
  const CoffeePage({super.key});

  @override
  Widget build(BuildContext context) {
    final coffeeRepository = context.read<CoffeeRepository>();
    return BlocProvider(
      create: (_) => CoffeeBloc(repository: coffeeRepository)
        ..add(
          CoffeeFetched(),
        ),
      child: const CoffeeView(),
    );
  }
}

class CoffeeView extends StatelessWidget {
  const CoffeeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocConsumer<CoffeeBloc, CoffeeState>(
      listener: (context, state) {
        context.read<CoffeeBloc>().add(MessagesReset());
        if (state.message != null && state.message!.isNotEmpty) {
          if (state.status == CoffeeStatus.success) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SuccessSnackBar(
                  state.message!,
                  theme: theme,
                ),
              );
          } else if (state.status == CoffeeStatus.failure) {
            final error = state.message != null
                ? state.message!
                : l10n.genericErrorSnackbarText;

            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                ErrorSnackBar(
                  error,
                  theme: theme,
                ),
              );
          }
        }
      },
      builder: (context, state) {
        return switch (state.status) {
          (CoffeeStatus.initial) => const Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: PlatformCircularProgressIndicator(),
            ),
          ),
          (CoffeeStatus.success || CoffeeStatus.failure) => const CoffeeList(),
        };
      },
    );
  }
}

class _CoffeeListState extends State<CoffeeList> {
  final _scrollController = ScrollController();
  bool filterByFavorites = false;

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (_scrollController.position.maxScrollExtent * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoffeeBloc, CoffeeState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilterChip(
                    label: Row(
                      spacing: 8,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: filterByFavorites
                              ? theme.colorScheme.primary
                              : theme.colorScheme.inverseSurface,
                        ),
                        const Text('Favorites'),
                      ],
                    ),
                    selected: filterByFavorites,
                    onSelected: (value) {
                      setState(() {
                        filterByFavorites = !filterByFavorites;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: filterByFavorites
                  ? ListView.builder(
                      controller: _scrollController,
                      itemCount: state.favorites.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: CoffeeItem(coffee: state.favorites[index]),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: _scrollController,
                      itemCount: state.hasReachedMax
                          ? state.coffees.length
                          : state.coffees.length + 1,
                      itemBuilder: (context, index) =>
                          index < state.coffees.length
                          ? Padding(
                              padding: const EdgeInsets.all(8),
                              child: CoffeeItem(coffee: state.coffees[index]),
                            )
                          : const BottomLoader(),
                    ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom && !filterByFavorites) {
      context.read<CoffeeBloc>().add(CoffeeFetched(batchSize: 5));
    }
  }
}
