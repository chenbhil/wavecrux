// Copyright 2026 Ferrite Engineering LLC
// SPDX-License-Identifier: Apache-2.0

// Repro: auto-detect on the edu-pack uart-lab trace (50 MHz, 434 clk/bit).
// tx edges copied verbatim from packs/uart-lab/fixtures/reference.vcd.

import 'package:flutter_test/flutter_test.dart';
import 'package:wavecrux/domain/enums/timescale_unit.dart';
import 'package:wavecrux/domain/models/timescale.dart';

import 'uart_decoder_test.dart' show makeChangesQuery, makeQuery;
import 'uart_timing_mode_test.dart' show decoderWith;

const _tx = <(int, String)>[
  (0, '1'),
  (80, '0'),
  (8760, '1'),
  (17440, '0'),
  (26120, '1'),
  (34800, '0'),
  (43480, '1'),
  (52160, '0'),
  (60840, '1'),
  (69520, '0'),
  (78200, '1'),
  (86920, '0'),
  (104280, '1'),
  (112960, '0'),
  (121640, '1'),
  (130320, '0'),
  (139000, '1'),
  (147680, '0'),
  (156360, '1'),
  (173760, '0'),
  (182440, '1'),
  (191120, '0'),
  (199800, '1'),
  (208480, '0'),
  (217160, '1'),
  (225840, '0'),
  (234520, '1'),
  (243200, '0'),
  (251880, '1'),
  (260600, '0'),
  (277960, '1'),
  (286640, '0'),
  (295320, '1'),
  (304000, '0'),
  (312680, '1'),
  (321360, '0'),
  (330040, '1'),
];

void main() {
  const ts = Timescale(factor: 1, unit: TimescaleUnit.nanoSeconds);
  final s = {'tx': _tx};
  String run(Map<String, dynamic> p) => [
    for (final t in decoderWith(
      p,
      withClock: false,
    ).decode(0, 348390, makeQuery(s), makeChangesQuery(s), timescale: ts))
      t.fields['data'] ?? '',
  ].join(' | ');

  test('baud 115200 decodes the pack bytes', () {
    expect(run({'baud_rate': 115200}), '0x55 0xAA 0x55 0xAA');
  });

  test('auto-detect decodes the pack bytes', () {
    expect(run({'timing_mode': 'auto'}), '0x55 0xAA 0x55 0xAA');
  });
}
