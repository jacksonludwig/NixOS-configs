# This file has been generated by node2nix 1.9.0. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {
    "camelize-1.0.0" = {
      name = "camelize";
      packageName = "camelize";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/camelize/-/camelize-1.0.0.tgz";
        sha1 = "164a5483e630fa4321e5af07020e531831b2609b";
      };
    };
    "core_d-1.1.0" = {
      name = "core_d";
      packageName = "core_d";
      version = "1.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/core_d/-/core_d-1.1.0.tgz";
        sha512 = "7soFrEC9BhEZVNhxV7lf+oF1zrI+BjeUg1uKjzmBUyBTK+GRYK08UuwP32t34ivN/p9kwzCFOevM2i6xcnoo9Q==";
      };
    };
    "function-bind-1.1.1" = {
      name = "function-bind";
      packageName = "function-bind";
      version = "1.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/function-bind/-/function-bind-1.1.1.tgz";
        sha512 = "yIovAzMX49sF8Yl58fSCWJ5svSLuaibPxXQJFLmBObTuCr0Mf1KiPopGM9NiFjiYBCbfaa2Fh6breQ6ANVTI0A==";
      };
    };
    "has-1.0.3" = {
      name = "has";
      packageName = "has";
      version = "1.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/has/-/has-1.0.3.tgz";
        sha512 = "f2dvO0VU6Oej7RkWJGrehjbzMAjFp5/VKPp5tTpWIV4JHHZK1/BxbFRtf/siA2SWTe09caDmVtYYzWEIbBS4zw==";
      };
    };
    "has-flag-3.0.0" = {
      name = "has-flag";
      packageName = "has-flag";
      version = "3.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz";
        sha1 = "b5d454dc2199ae225699f3467e5a07f3b955bafd";
      };
    };
    "is-core-module-2.4.0" = {
      name = "is-core-module";
      packageName = "is-core-module";
      version = "2.4.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/is-core-module/-/is-core-module-2.4.0.tgz";
        sha512 = "6A2fkfq1rfeQZjxrZJGerpLCTHRNEBiSgnu0+obeJpEPZRUooHgsizvzv0ZjJwOz3iWIHdJtVWJ/tmPr3D21/A==";
      };
    };
    "minimist-1.2.5" = {
      name = "minimist";
      packageName = "minimist";
      version = "1.2.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/minimist/-/minimist-1.2.5.tgz";
        sha512 = "FM9nNUYrRBAELZQT3xeZQ7fmMOBg6nWNmJKTcgsJeaLstP/UODVpGsr5OhXhhXg6f+qtJ8uiZ+PUxkDWcgIXLw==";
      };
    };
    "nanolru-1.0.0" = {
      name = "nanolru";
      packageName = "nanolru";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/nanolru/-/nanolru-1.0.0.tgz";
        sha512 = "GyQkE8M32pULhQk7Sko5raoIbPalAk90ICG+An4fq6fCsFHsP6fB2K46WGXVdoJpy4SGMnZ/EKbo123fZJomWg==";
      };
    };
    "path-parse-1.0.7" = {
      name = "path-parse";
      packageName = "path-parse";
      version = "1.0.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz";
        sha512 = "LDJzPVEEEPR+y48z93A0Ed0yXb8pAByGWo/k5YYdYgpY2/2EsOsksJrq7lOHxryrVOn1ejG6oAp8ahvOIQD8sw==";
      };
    };
    "prettier-1.19.1" = {
      name = "prettier";
      packageName = "prettier";
      version = "1.19.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/prettier/-/prettier-1.19.1.tgz";
        sha512 = "s7PoyDv/II1ObgQunCbB9PdLmUcBZcnWOcxDh7O0N/UwDEsHyqkW+Qh28jW+mVuCdx7gLB0BotYI1Y6uI9iyew==";
      };
    };
    "resolve-1.20.0" = {
      name = "resolve";
      packageName = "resolve";
      version = "1.20.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/resolve/-/resolve-1.20.0.tgz";
        sha512 = "wENBPt4ySzg4ybFQW2TT1zMQucPK95HSh/nq2CFTZVOGut2+pQvSsgtda4d26YrYcr067wjbmzOG8byDPBX63A==";
      };
    };
    "supports-color-5.5.0" = {
      name = "supports-color";
      packageName = "supports-color";
      version = "5.5.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz";
        sha512 = "QjVjwdXIt408MIiAqCX4oUKsgU2EqAGzs2Ppkm4aQYbjm+ZEWEcW4SfFNTr4uMNZma0ey4f5lgLrkB0aX0QMow==";
      };
    };
  };
in
{
  prettier_d_slim = nodeEnv.buildNodePackage {
    name = "prettier_d_slim";
    packageName = "prettier_d_slim";
    version = "1.0.0";
    src = fetchurl {
      url = "https://registry.npmjs.org/prettier_d_slim/-/prettier_d_slim-1.0.0.tgz";
      sha512 = "XMnrGBOw0CVofX6LvuSFepJ86Zz5Zn9bHo6h6uWVLGjdqZtJ+MyXZxIjqxsrlMU12HORNu7vDbdM93f0zwlEBw==";
    };
    dependencies = [
      sources."camelize-1.0.0"
      sources."core_d-1.1.0"
      sources."function-bind-1.1.1"
      sources."has-1.0.3"
      sources."has-flag-3.0.0"
      sources."is-core-module-2.4.0"
      sources."minimist-1.2.5"
      sources."nanolru-1.0.0"
      sources."path-parse-1.0.7"
      sources."prettier-1.19.1"
      sources."resolve-1.20.0"
      sources."supports-color-5.5.0"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "Makes prettier fast";
      homepage = "https://github.com/mikew/prettier_d_slim";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}
