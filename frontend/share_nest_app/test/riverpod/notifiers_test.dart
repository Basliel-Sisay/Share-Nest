import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_nest_app/core/providers/app_providers.dart';
void main(){
  test('BrowseSearchNotifier updates state', (){
    final container = ProviderContainer();
    final notifier = container.read(browseSearchProvider.notifier);
    expect(container.read(browseSearchProvider), '');
    notifier.setQuery('test');
    expect(container.read(browseSearchProvider), 'test');
  });
  test('BrowseCategoryNotifier updates state', (){
    final container = ProviderContainer();
    final notifier = container.read(browseCategoryProvider.notifier);
    expect(container.read(browseCategoryProvider), 'All Resources');
    notifier.setCategory('Tools');
    expect(container.read(browseCategoryProvider), 'Tools');
  });
}
