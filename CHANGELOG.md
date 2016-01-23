
#### [1.2.0] - 2016-20-01
* fixed `removePieceAtIndex:`
* fixed `insertChartValue:atIndex:`
* `setValues:` - deleted, use `setValue:pieceAtIndex:`
* improved documentation for simple start
* added couple more examples
* JSON example
* fixed animations
* UIColor category included back for JSON reason



#### [1.1.1] - 2016-20-01
* fixed initWithFrame
* improved documentation for simple start

#### [1.1.0] - 2016-20-01
* `VBPiePiece` - made fully private, and all members are `readonly`
* from float -> double
* some little more commnets

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
