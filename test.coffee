anon = require './anon'
assert = require('chai').assert

compareIps = anon.compareIps
isIpInRange = anon.isIpInRange
isIpInAnyRange = anon.isIpInAnyRange

describe 'anon', ->

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

    it 'ip in cidr range', ->
      assert.isTrue isIpInRange '123.123.123.123', '123.123.0.0/16'

    it 'ip is not in cidr range', ->
      assert.isFalse isIpInRange '123.123.123.123', '123.123.123.122/32'

  describe 'isIpInAnyRange', ->

    r1 = ['1.1.1.0', '1.1.1.5']
    r2 = ['2.2.2.0', '2.2.2.5']

    it 'ip in first range', ->
      assert.isTrue isIpInAnyRange '1.1.1.1', [r1, r2]

    it 'ip in second range', ->
      assert.isTrue isIpInAnyRange '2.2.2.1', [r1, r2]

    it 'ip not in any ranges', ->
      assert.isFalse isIpInAnyRange '1.1.1.6', [r1, r2]
      
  describe 'IP Range Error (#12)', ->

    it 'false positive not in ranges', ->
      assert.isFalse isIpInAnyRange '199.19.250.20', [["199.19.16.0", "199.19.27.255"], ["4.42.247.224", "4.42.247.255"]]
