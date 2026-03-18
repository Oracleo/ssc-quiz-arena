const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');

const repoRoot = path.resolve(__dirname, '..');
const sdkDir = path.join(repoRoot, '.vercel', 'cache', 'flutter-sdk');
const flutterExecutable = path.join(
  sdkDir,
  'bin',
  process.platform === 'win32' ? 'flutter.bat' : 'flutter',
);

function run(command, args, options = {}) {
  const result = spawnSync(command, args, {
    stdio: 'inherit',
    cwd: repoRoot,
    env: process.env,
    shell: process.platform === 'win32',
    ...options,
  });

  if (result.status !== 0) {
    process.exit(result.status || 1);
  }
}

function commandOnPath(command) {
  const probe = spawnSync(process.platform === 'win32' ? 'where' : 'which', [command], {
    encoding: 'utf8',
    shell: process.platform === 'win32',
  });

  if (probe.status !== 0) {
    return null;
  }

  const match = probe.stdout
      .split(/\r?\n/)
      .map((line) => line.trim())
      .find(Boolean);

  return match || null;
}

function ensureFlutterSdk() {
  const systemFlutter = commandOnPath('flutter');
  if (systemFlutter) {
    return systemFlutter;
  }

  if (!fs.existsSync(flutterExecutable)) {
    fs.mkdirSync(path.dirname(sdkDir), { recursive: true });
    run('git', [
      'clone',
      '--depth',
      '1',
      '--branch',
      'stable',
      'https://github.com/flutter/flutter.git',
      sdkDir,
    ]);
  }

  return flutterExecutable;
}

function flutter(flutterPath, args) {
  const env = {
    ...process.env,
    CI: process.env.CI || '1',
    FLUTTER_ROOT: path.dirname(path.dirname(flutterPath)),
    PUB_CACHE: process.env.PUB_CACHE || path.join(os.homedir(), '.pub-cache'),
  };

  run(flutterPath, args, { env });
}

function install() {
  const flutterPath = ensureFlutterSdk();
  flutter(flutterPath, ['config', '--enable-web', '--no-analytics']);
  flutter(flutterPath, ['pub', 'get']);
}

function build() {
  install();
  const flutterPath = ensureFlutterSdk();
  flutter(flutterPath, ['clean']);
  flutter(flutterPath, ['pub', 'get']);
  flutter(flutterPath, [
    'build',
    'web',
    '--release',
    '--wasm',
    '--optimization-level=4',
  ]);
}

const mode = process.argv[2];

if (mode === 'install') {
  install();
} else if (mode === 'build') {
  build();
} else {
  console.error('Usage: node scripts/vercel_flutter_build.js <install|build>');
  process.exit(1);
}
