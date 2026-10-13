// The zips that build-aux/pack.sh makes: the files that extensions.gnome.org
// is to get, real files in the place of the links to gnome-common/, and the
// same bytes for the same tree.
import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {mkdtempSync, readFileSync, rmSync} from 'node:fs';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {after, test} from 'node:test';

const root = new URL('../', import.meta.url).pathname;
const out = mkdtempSync(join(tmpdir(), 'pack-'));
after(() => rmSync(out, {recursive: true, force: true}));

const pack = (dir) =>
    execFileSync(join(root, 'build-aux/pack.sh'), [dir, out], {encoding: 'utf8'}).trim();
const list = (zip) =>
    execFileSync('unzip', ['-Z1', zip], {encoding: 'utf8'}).trim().split('\n').sort();
const entry = (zip, name) => execFileSync('unzip', ['-p', zip, name], {encoding: 'utf8'});

const EXTENSIONS = {
    'gnome-keys': [
        'LICENSE',
        'display.js',
        'extension.js',
        'layout.js',
        'metadata.json',
        'schemas/gschemas.compiled',
        'schemas/org.gnome.shell.extensions.asus-zenbook-duo-ux8406-keys.gschema.xml',
        'state.js',
        'touch.js',
    ],
    'gnome-rotation': [
        'LICENSE',
        'display.js',
        'extension.js',
        'metadata.json',
        'rotation.js',
        'sensor.js',
        'state.js',
    ],
};

for (const [dir, files] of Object.entries(EXTENSIONS)) {
    test(`${dir}: the zip has the name of the uuid and only the files of the extension`, () => {
        const {uuid} = JSON.parse(readFileSync(join(root, dir, 'extension/metadata.json'), 'utf8'));
        const zip = pack(dir);
        assert.equal(zip, join(out, `${uuid}.shell-extension.zip`));
        assert.deepEqual(list(zip), files);
    });

    test(`${dir}: the shared modules are copies of gnome-common`, () => {
        const zip = pack(dir);
        for (const name of ['display.js', 'state.js'])
            assert.equal(entry(zip, name), readFileSync(join(root, 'gnome-common', name), 'utf8'));
    });

    test(`${dir}: the zip is the same at each build`, () => {
        const first = readFileSync(pack(dir));
        assert.deepEqual(readFileSync(pack(dir)), first);
    });
}
