import 'dart:io';

import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:very_good_coffee/app/shared/snackbars.dart';
import 'package:very_good_coffee/explore_coffee/bloc/explore_coffee_bloc.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

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
    final bloc = context.read<ExploreCoffeeBloc>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      coffee.url.toString(),
                      fit: BoxFit.fill,
                    ),
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
                          padding: const EdgeInsets.all(8),
                          onPressed: () => bloc.add(CoffeeFavorited(coffee)),
                          icon: const Icon(Icons.favorite),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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

class ExploreCoffeePage extends StatelessWidget {
  const ExploreCoffeePage({super.key});

  @override
  Widget build(BuildContext context) {
    final coffeeRepository = context.read<CoffeeRepository>();
    return BlocProvider(
      create: (_) =>
          ExploreCoffeeBloc(repository: coffeeRepository)
            ..add(CoffeeFetched()), // Immediately grab a coffee on load
      child: const ExploreCoffeeView(),
    );
  }
}

class ExploreCoffeeView extends StatelessWidget {
  const ExploreCoffeeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<ExploreCoffeeBloc>();
    final theme = Theme.of(context);

    return BlocConsumer<ExploreCoffeeBloc, ExploreCoffeeState>(
      listener: (context, state) {
        if (Platform.isIOS) {
          showCupertinoModalPopup(
            context: context,
            builder: (context) => const Text('Hi'),
          );
        }

        if (state.status == ExploreCoffeeStatus.failure) {
          if (Platform.isAndroid) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                ErrorSnackBar(l10n.genericErrorSnackbarText, theme: theme),
              );
          } else if (Platform.isIOS) {
            Overlay.of(
              context,
            ).insert(OverlayEntry(builder: (context) => const Text('hi')));
          }
        }
      },
      builder: (context, state) {
        return switch (state.status) {
          (ExploreCoffeeStatus.initial) => const Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: PlatformCircularProgressIndicator(),
            ),
          ), // TODO(ant): skeleton list loader
          (ExploreCoffeeStatus.success) => const CoffeeList(),

          (ExploreCoffeeStatus.failure) => const Text('Error'),
        };
      },
    );
  }
}

class _CoffeeListState extends State<CoffeeList> {
  final _scrollController = ScrollController();

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (_scrollController.position.maxScrollExtent * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreCoffeeBloc, ExploreCoffeeState>(
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: state.hasReachedMax
              ? state.coffees.length
              : state.coffees.length + 1,
          itemBuilder: (context, index) => index < state.coffees.length
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: CoffeeItem(coffee: state.coffees[index]),
                )
              : const BottomLoader(),
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
    if (_isBottom) context.read<ExploreCoffeeBloc>().add(CoffeeFetched());
  }
}
