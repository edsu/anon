const fs = require('fs')
const anon = require('./anon')

const { assert } = require('chai')
const { compareIps, isIpInRange, isIpInAnyRange } = anon

describe('anon', function() {

  describe("compareIps ipv4", function() {
    it('equal', () => assert.equal(0, compareIps('1.1.1.1', '1.1.1.1')))
    it('greater than', () => assert.equal(1, compareIps('1.1.1.2', '1.1.1.1')))
    it('less than', () => assert.equal(-1, compareIps('1.1.1.1', '1.1.1.2')))
  })

  describe("compareIps ipv6", function() {
    it('equal', () => assert.equal(0, compareIps('2601:8:b380:3f3:540b:fdbf:bc5:a6bf', '2601:8:b380:3f3:540b:fdbf:bc5:a6bf')))
    it('greater than', () => assert.equal(1, compareIps('2600:8:b380:3f3:540b:fdbf:bc5:a6bf', '2600:8:b380:3f3:540b:fdbf:bc5:a6be')))
    it('less than', () => assert.equal(-1, compareIps('2600:8:b380:3f3:540b:fdbf:bc5:a6be', '2601:8:b380:3f3:540b:fdbf:bc5:a6bf')))
  });

  describe('isIpInRange ipv4', function() {
    it('ip in range', () => assert.isTrue(isIpInRange('123.123.123.123', ['123.123.123.0', '123.123.123.255'])))
    it('ip less than range', () => assert.isFalse(isIpInRange('123.123.122.123', ['123.123.123.0', '123.123.123.123'])))
    it('ip greater than range', () => assert.isFalse(isIpInRange('123.123.123.123', ['123.123.123.0', '123.123.123.122'])))
    it('ip in cidr range', () => assert.isTrue(isIpInRange('123.123.123.123', '123.123.0.0/16')))
    it('ip is not in cidr range', () => assert.isFalse(isIpInRange('123.123.124.1', '123.123.123.0/24')))
  });

  describe('isIpInRange ipv6', function() {
    it('ipv6 in range', () => assert.isTrue(isIpInRange('0000:0000:0000:0000:0000:0000:0000:0001', ['0000:0000:0000:0000:0000:0000:0000:0000', '0000:0000:0000:0000:0000:0000:0000:0002'])))
    it('ipv6 not in range', () => assert.isFalse(isIpInRange('0000:0000:0000:0000:0000:0000:0000:0001', ['0000:0000:0000:0000:0000:0000:0000:0002', '0000:0000:0000:0000:0000:0000:0000:0003'])))
    it('ipv4 in ipv6 range', () => assert.isTrue(isIpInRange('127.0.0.1', ['0:0:0:0:0:ffff:7f00:1', '0:0:0:0:0:ffff:7f00:2'])))
    it('ipv4 not in ipv6 range', () => assert.isFalse(isIpInRange('127.0.0.3', ['0:0:0:0:0:ffff:7f00:1', '0:0:0:0:0:ffff:7f00:2'])))
    it('ipv6 in ipv6 cidr', () => assert.isTrue(isIpInRange('0000:0000:0000:0000:0000:0000:1000:0005', '0000:0000:0000:0000:0000:0000:1000:0000/112')))
    it('ipv6 in ipv4 cidr', () => assert.isTrue(isIpInRange('0:0:0:0:0:ffff:8e33:1', '142.51.0.0/16')))
    it('ipv6 not in ipv4 cidr', () => assert.isFalse(isIpInRange('0:0:0:0:0:ffff:8e34:1', '142.51.0.0/16')))
  });

  describe('isIpInAnyRange', function() {

    const r1 = ['1.1.1.0', '1.1.1.5']
    const r2 = ['2.2.2.0', '2.2.2.5']

    it('ip in first range', () => assert.isTrue(isIpInAnyRange('1.1.1.1', [r1, r2])))
    it('ip in second range', () => assert.isTrue(isIpInAnyRange('2.2.2.1', [r1, r2])))
    it('ip not in any ranges', () => assert.isFalse(isIpInAnyRange('1.1.1.6', [r1, r2])))
    it('false positive not in ranges #12', function() {
      assert.isFalse(isIpInAnyRange('199.19.250.20', [["199.19.16.0", "199.19.27.255"], ["4.42.247.224", "4.42.247.255"]]))
      assert.isFalse(isIpInAnyRange('39.255.255.148', [["40.0.0.0", "40.127.255.255"], ["40.144.0.0", "40.255.255.255"]]))
    })
  })

  describe('getStatus', function() {
    it('works', function() {
      const edit = {page: 'Foo', url: 'http://example.com'}
      const name = 'Bar'
      const template = "{{page}} edited by {{name}} {{&url}}"
      const result = anon.getStatus(edit, name, template)
      assert.equal('Foo edited by Bar http://example.com', result)
    })
    it('truncates when > 140 chars', function() {
      // twitter shortens all urls, so we use a shortened one here
      const edit = {
        page: Array(140).join('x'),
        url: 'http://t.co/BzHLWr31Ce'
      }
      const name = 'test'
      const template = "{{page}} edited by {{name}} {{&url}}"
      const result = anon.getStatus(edit, name, template)
      assert.isTrue(result.length <= 140)
    })
  })

  describe('takeScreenshot', function() {
    it('works', function(done) {
      this.timeout(20000)
      const url = 'https://en.wikipedia.org/w/index.php?diff=619968907&oldid=619663144'
      anon.takeScreenshot(url).then(function(path) {
        fs.stat('package.json', (err, stat) => {
          assert.isNull(err)
          assert.isTrue(stat.size > 0)
          fs.unlink(path, done)
        })
      })
    })
  })

})
