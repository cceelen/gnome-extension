// Tests for machine.js. Run with `node --test`. The UX8406 names are as the DMI
// gives them; the UX8407 name is not reported yet and follows their pattern.
import assert from 'node:assert/strict';
import {test} from 'node:test';

import {isSupportedModel} from '../extension/machine.js';

for (const [productName, supported] of [
    ['ASUS Zenbook Duo UX8406CA_UX8406CA\n', true],
    ['ASUS Zenbook Duo UX8406MA_UX8406MA\n', true],
    ['ASUS Zenbook Duo UX8407AA_UX8407AA\n', true],
    ['ASUS Zenbook 14 UX3405MA_UX3405MA\n', false],
    ['', false],
]) {
    test(`${JSON.stringify(productName)} is ${supported ? '' : 'not '}supported`, () => {
        assert.equal(isSupportedModel(productName), supported);
    });
}
