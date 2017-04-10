## ROADMAP 1.0.0

* add `with_side_effect(&blk)` for specifying desired side effects

## RELEASE 0.3.1

* FIX: ``Kernel.` ``, `Kernel.exec`, and `Kernel.system` are now all supported as well. This is useful to testing thor suites that shell out, because thor (for reasons passing understanding) redefines `#exec`, so we have to resort to `Kernel.exec`.

## RELEASE 0.3.0

* FEATURE: you can now stub & mock `Kernel#exec`.

## RELEASE 0.2.2

* FIX: fixed a test ordering bug
