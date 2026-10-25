import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:balloon_crazy/features/adventure/application/level_one_controller.dart';

class V2LevelOneScreen extends StatefulWidget {
  const V2LevelOneScreen({super.key});

  @override
  State<V2LevelOneScreen> createState() => _V2LevelOneScreenState();
}

class _V2LevelOneScreenState extends State<V2LevelOneScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final V2LevelOneController controller;
  late final Ticker _ticker;
  Duration _previousFrame = Duration.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = V2LevelOneController();
    _ticker = createTicker(_onFrame);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker.dispose();
    controller.dispose();
    super.dispose();
  }

  void _beginLevel() {
    controller.begin();
    _previousFrame = Duration.zero;
    _ticker.start();
  }

  void _onFrame(Duration elapsed) {
    final delta = elapsed - _previousFrame;
    _previousFrame = elapsed;
    final seconds = delta.inMicroseconds / Duration.microsecondsPerSecond;
    controller.tick(seconds.clamp(0, 0.05));
    if (controller.phase == V2LevelOnePhase.results) _ticker.stop();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (controller.phase == V2LevelOnePhase.playing && !_ticker.isActive) {
        _previousFrame = Duration.zero;
        _ticker.start();
      }
      return;
    }
    if (_ticker.isActive) _ticker.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff36a9e1), Color(0xffb7ef9b)],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, _) => Column(
              children: [
                _V2Header(controller: controller),
                Expanded(child: _buildState(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildState(BuildContext context) {
    switch (controller.phase) {
      case V2LevelOnePhase.briefing:
        return _BriefingCard(onStart: _beginLevel);
      case V2LevelOnePhase.playing:
        return _PlayableBoard(controller: controller);
      case V2LevelOnePhase.results:
        return _ResultsCard(controller: controller, onReplay: _replay);
    }
  }

  void _replay() {
    controller.restart();
    if (_ticker.isActive) _ticker.stop();
    _previousFrame = Duration.zero;
  }
}

class _V2Header extends StatelessWidget {
  const _V2Header({required this.controller});

  final V2LevelOneController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'BALLOON CRAZY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Text(
            'LEVEL 1',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _BriefingCard extends StatelessWidget {
  const _BriefingCard({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.park_rounded,
                size: 72,
                color: Color(0xff168aad),
              ),
              const SizedBox(height: 12),
              const Text(
                'FIRST LIFT',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'Catch 8 balloons in the Meadow.\nMove under each balloon before it reaches the floor.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.35),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onStart,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text('START LEVEL'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayableBoard extends StatelessWidget {
  const _PlayableBoard({required this.controller});

  final V2LevelOneController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardWidth = constraints.maxWidth.clamp(280.0, 560.0);
        final boardHeight = constraints.maxHeight;
        return Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (details) =>
                controller.movePlayer(details.localPosition.dx / boardWidth),
            onPanUpdate: (details) =>
                controller.movePlayer(details.localPosition.dx / boardWidth),
            child: SizedBox(
              width: boardWidth,
              height: boardHeight,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  const Positioned.fill(child: _MeadowBackdrop()),
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: _ObjectiveBar(controller: controller),
                  ),
                  Positioned(
                    top: boardHeight * controller.balloonY,
                    left: boardWidth * controller.balloonX - 24,
                    child: Image.asset(
                      'assets/images/balloon_red.png',
                      width: 48,
                      height: 64,
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: boardWidth * controller.playerX - 42,
                    child: Image.asset(
                      'assets/images/player.png',
                      width: 84,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xff4f772d),
                        border: Border(top: BorderSide(color: Colors.white24)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ObjectiveBar extends StatelessWidget {
  const _ObjectiveBar({required this.controller});

  final V2LevelOneController controller;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'CATCH ${controller.catches}/8',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'SCORE ${controller.score}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: controller.objectiveProgress,
              minHeight: 8,
              color: const Color(0xffffd166),
              backgroundColor: Colors.white24,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  '♥ ' * controller.lives,
                  style: const TextStyle(
                    color: Color(0xffff6b6b),
                    fontSize: 17,
                  ),
                ),
                const Spacer(),
                Text(
                  'STACK ${controller.held}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MeadowBackdrop extends StatelessWidget {
  const _MeadowBackdrop();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _MeadowPainter());
  }
}

class _MeadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0x2238a3db);
    canvas.drawCircle(Offset(size.width * .2, size.height * .32), 90, paint);
    canvas.drawCircle(Offset(size.width * .82, size.height * .22), 130, paint);
    paint.color = const Color(0x4454b948);
    final hill = Path()
      ..moveTo(0, size.height * .74)
      ..quadraticBezierTo(
        size.width * .25,
        size.height * .62,
        size.width * .5,
        size.height * .74,
      )
      ..quadraticBezierTo(
        size.width * .75,
        size.height * .88,
        size.width,
        size.height * .68,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ResultsCard extends StatelessWidget {
  const _ResultsCard({required this.controller, required this.onReplay});

  final V2LevelOneController controller;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    final won = controller.isWon;
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                won ? Icons.emoji_events_rounded : Icons.refresh_rounded,
                size: 72,
                color: won ? const Color(0xffffb703) : const Color(0xff168aad),
              ),
              const SizedBox(height: 12),
              Text(
                won ? 'LEVEL COMPLETE' : 'KEEP TRYING',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Caught ${controller.catches}/${controller.target}  •  Score ${controller.score}',
              ),
              const SizedBox(height: 6),
              Text('Lives remaining: ${controller.lives}'),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onReplay,
                icon: const Icon(Icons.replay_rounded),
                label: const Text('PLAY AGAIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
