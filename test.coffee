assert = require('chai').assert
congressEdits = require './congressedits'

compareIps = congressEdits.compareIps
isIpInRange = congressEdits.isIpInRange
isIpInAnyRange = congressEdits.isIpInAnyRange

describe 'congressedits', ->

  describe "compareIps", ->
    it 'equal', ->
      assert.equal 0, compareIps '1.1.1.1', '1.1.1.1'
    it 'greater than', ->
      assert.equal 1, compareIps '1.1.1.2', '1.1.1.1'
    it 'less than', ->
      assert.equal -1, compareIps '1.1.1.1', '1.1.1.2'

  describe 'isIpInRange', ->

    it 'ip in range', ->
      assert.isTrue isIpInRange '123.123.123.123', ['123.123.123.0', '123.123.123.255']

    it 'ip less than range', ->
      assert.isFalse isIpInRange '123.123.122.123', ['123.123.123.0', '123.123.123.123']

    it 'ip greater than range', ->
      assert.isFalse isIpInRange '123.123.123.123', ['123.123.123.0', '123.123.123.122']

  describe 'isIpInAnyRange', ->
    r1 = ['1.1.1.0', '1.1.1.5']
    r2 = ['2.2.2.0', '2.2.2.5']

    it 'ip in first range', ->
      assert.isTrue isIpInAnyRange '1.1.1.1', [r1, r2]

    it 'ip in second range', ->
      assert.isTrue isIpInAnyRange '2.2.2.1', [r1, r2]

    it 'ip not in any ranges', -
      assert.isFalse isIpInAnyRange '1.1.1.6', [r1, r2]

