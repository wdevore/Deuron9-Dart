// https://support.minitab.com/en-us/minitab-express/1/help-and-how-to/basic-statistics/probability-distributions/supporting-topics/distributions/poisson-distribution/
// Poisson is commonly used for modelling the number of occurrences
// of an event within a particular time interval.
// For example, we may want an average of 20 spikes to occur within
// a 1 sec interval.
// Note: where the spikes occur within the interval is random, but
// we expect to average 20 spikes within that interval.

// What is rate of occurrence?
// The rate of occurrence equals the mean (λ) divided by the dimension
// of your observation space (interval). It is useful for comparing Poisson
// counts collected in different observation spaces.
// For example, Switchboard A receives 50 telephone calls in 5 hours,
// and Switchboard B receives 80 calls in 10 hours.
// You cannot directly compare these values because their observation
// spaces are different.
// You must calculate the occurrence rate to compare these counts.
// The rate for Switchboard A is (50 calls / 5 hours) = 10 calls/hour.
// The rate for Switchboard B is (80 calls / 10 hours) = 8 calls/hour.

// Generating:
// If you have a Poisson process with rate parameter
// L (meaning that, long term, there are L arrivals per second),
// then the inter-arrival times are exponentially distributed with
// mean 1/L.
// So the PDF is f(t) = -L*exp(-Lt),
// and the CDF is F(t) = Prob(T < t) = 1 - exp(-Lt).
// So your problem changes to: how do I generate a random number t
// with distribution F(t) = 1 - \exp(-Lt)?

// Assuming the language you are using has a function (let's call it rand())
// to generate random numbers uniformly distributed between 0 and 1,
// the inverse CDF technique reduces to calculating: -log(rand()) / L

import 'dart:math';

import 'package:data/data.dart';

import '../model/model.dart';
import 'ibit_stream.dart';

class PoissonStream implements IBitStream {
  late PoissonDistribution poisson;
  late PoissonDistribution poisson2;

  // The Interspike interval (ISI) is a counter
  // When the counter reaches 0 a spike is placed on the output
  // for single pass.
  int isi = 0;

  // λ is the shape parameter which indicates the 'average' number of
  // events in the given time interval
  double averagePerInterval = 0.0;

  int seed = 0;
  Random rando = Random();

  int outputSpike = 0;

  PoissonStream();

  factory PoissonStream.create(int seed, double averagePerInterval) {
    PoissonStream ps = PoissonStream();

    ps.seed = seed;
    ps.averagePerInterval = averagePerInterval; // Lambda
    ps.rando = Random(seed);

    ps.poisson = PoissonDistribution(averagePerInterval);
    ps.poisson2 = PoissonDistribution(averagePerInterval / 2.5);

    ps.reset();

    return ps;
  }

  @override
  int output() {
    return outputSpike;
  }

  @override
  reset() {
    rando = Random(seed);
    poisson = PoissonDistribution(averagePerInterval);
    isi = next();
    outputSpike = 0;
  }

  @override
  step() {
    if (isi == 0) {
      // Time to generate a spike
      isi = next();
      outputSpike = 1;
    } else {
      isi--;
      outputSpike = 0;
    }
  }

  @override
  update(Model model) {
    averagePerInterval = model.noiseLambda;
  }

  // Create an event per interval of time, for example, spikes in a 1 sec span.
  // A firing rate given in rate/ms, for example, 0.2 in 1ms (0.2/1)
  // or 200 in 1sec (200/1000ms)
  int next() {
    int r = poisson.sample(random: rando);
    int r2 = poisson2.sample(random: rando);
    // poisson2.sample(random: rando);
    // double div = 64.0 - 1.0; // Nbits - 1
    r = (rando.nextDouble() * r * r2).toInt();
    return r;

    // isiF := -math.Log(1.0-r) / averagePerInterval
    // fmt.Print(isiF, "  ")
    // return int64(math.Round(isiF))
  }
}
