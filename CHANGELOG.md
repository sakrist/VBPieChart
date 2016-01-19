#### [1.0.0] - 2016-19-01
* UIColor+HexColor - moved out of pod
* new documentation for `VBPieChart` class
* fixed issues with passing wrong data
* new `VBPieChartAnimationDefault`
* new `insertChartValue:atIndex:`
* reverted `- (NSArray *) chartValues;`
* fixed accent vector
* some more Unit Tests

#### [0.4.1] - 2016-18-01
* fixed crash for empty `chartValues`
* fixed `removePieceAtIndex:` if animations disabled
* implemented some simple Tests
* travis updated

#### [0.4.0] - 2016-17-01
* `chartValues` moved to private, added `setChartValues:` instead
* `setValue:forIndex:` renamed to `setValue:pieceAtIndex:`
* new `removePieceAtIndex:`
* fixed Accent with different `startAngle`
* `VBLabelBlock` now have one more parameter
* `strokeColor` and `enableStrokeColor` **DEPRECATED**
* `enableInteractive` **DEPRECATED**
* `accentVector` in VBPiePiece
