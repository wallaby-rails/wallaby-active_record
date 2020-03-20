# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [TODO]

- Move translation from wallaby-core to here

## [0.2.3](https://github.com/wallaby-rails/wallaby-active_record/releases/tag/0.2.3) - 2020-03-20

### Changed

- fix: use and to join the conditions for not in ([#10](https://github.com/wallaby-rails/wallaby-active_record/pull/10))

## [0.2.2](https://github.com/wallaby-rails/wallaby-active_record/releases/tag/0.2.2) - 2020-03-19

### Changed

- fix: nil must be handled differently in a sequence sub query ([#9](https://github.com/wallaby-rails/wallaby-active_record/pull/9))
- fix: check database and table's existence before getting the metadata. ([#8](https://github.com/wallaby-rails/wallaby-active_record/pull/8))
- chore: use simplecov 0.17 for codeclimate report ([#7](https://github.com/wallaby-rails/wallaby-active_record/pull/7))

## [0.2.1](https://github.com/wallaby-rails/wallaby-active_record/releases/tag/0.2.1) - 2020-02-17

### Changed

- fix: convert per_page param to integer for will_paginate ([#6](https://github.com/wallaby-rails/wallaby-active_record/pull/6))

## [0.2.0](https://github.com/wallaby-rails/wallaby-active_record/releases/tag/0.2.0) - 2020-02-16

### Changed

- chore: remove kaminari from dependency but make it work with both kaminari and will_paginate ([#5](https://github.com/wallaby-rails/wallaby-active_record/pull/5))
- feat: improve querier to allow null, empty string and string matching query ([#4](https://github.com/wallaby-rails/wallaby-active_record/pull/4))

## [0.1.0](https://github.com/wallaby-rails/wallaby-active_record/releases/tag/0.1.0) - 2019-10-01

### Added
Extracted code from Wallaby
