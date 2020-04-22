import 'dart:io';

extension DirectoryUtils on Directory {
  Future<Directory> renameIfExists(String name) async {
    if (await this.exists()) {
      return await this.rename(name);
    }
    return this;
  }

  Directory renameIfExistsSync(String name) {
    if (existsSync()) {
      return this.renameSync(name);
    }
    return this;
  }

  Future<Directory> createIfNotExist() async {
    if (!(await this.exists())) {
      return await this.create(recursive: true);
    }
    return this;
  }

  void createIfNotExistSync() {
    if (!existsSync()) {
      return this.createSync(recursive: true);
    }
  }

  Future<void> removeIfExists() async {
    if (await exists()) {
      await delete(recursive: true);
    }
  }

  void removeIfExistsSync() {
    if (existsSync()) {
      deleteSync(recursive: true);
    }
  }
}
