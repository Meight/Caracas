import 'providers/OpenWeatherMapProvider.dart';
import 'providers/MockWeatherProvider.dart';
import 'providers/WeatherProvider.dart';
import 'package:dioc/dioc.dart';

abstract class AppBootsrapper extends Bootsrapper {
  @Provide(WeatherProvider, MockWeatherProvider)
  Container development();

  @Provide(WeatherProvider, OpenWeatherMapProvider)
  Container production();
}

class _AppBootsrapper implements AppBootsrapper {
  Container base() {
    final container = new Container();
    return container;
  }

  Container development() {
    final container = base();
    container.register(WeatherProvider, (c) => new MockWeatherProvider());
    return container;
  }

  Container production() {
    final container = base();
    container.register(WeatherProvider, (c) => new OpenWeatherMapProvider());
    return container;
  }
}

class AppBootsrapperBuilder  {
  static final AppBootsrapper instance = build();
  static AppBootsrapper build() => new _AppBootsrapper();
}