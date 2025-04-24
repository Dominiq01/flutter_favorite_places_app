import 'package:flutter/material.dart';
import 'package:flutter_favorite_places_app/providers/places_provider.dart';
import 'package:flutter_favorite_places_app/screens/new_place.dart';
import 'package:flutter_favorite_places_app/screens/place_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() {
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(placesProvider.notifier).loadPlaces();
  }

  void _setScreen() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => NewPlaceScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final placesList = ref.watch(placesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your places",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        actions: [
          IconButton(onPressed: _setScreen, icon: const Icon(Icons.add)),
        ],
      ),
      body:
          placesList.isEmpty
              ? Center(
                child: Text(
                  'No places added yet.',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(12),
                child: FutureBuilder(
                  future: _placesFuture,
                  builder:
                      (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                itemCount: placesList.length,
                                itemBuilder:
                                    (context, index) => ListTile(
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: FileImage(
                                          placesList[index].image,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (ctx) => PlaceDetailsScreen(
                                                  place: placesList[index],
                                                ),
                                          ),
                                        );
                                      },
                                      title: Text(
                                        placesList[index].name,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium!.copyWith(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                    ),
                              ),
                ),
              ),
    );
  }
}
