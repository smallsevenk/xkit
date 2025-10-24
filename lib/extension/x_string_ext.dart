/*
 * 文件名称: x_string_ext.dart
 * 创建时间: 2025/10/22 16:31:57
 * 作者名称: Andy.Zhao
 * 联系方式: smallsevenk@vip.qq.com
 * 创作版权: Copyright (c) 2025 XianHua Zhao (andy)
 * 功能描述:  
 */

extension StringExt on String {
  // AI播放消息内容处理 去除从"["/"!["开始到"]"结尾中间的内容,和 从"(http"开始到")"结尾中间的内容 的内容,并删除换行、空格，其他情况保留
  String get aiPlayMessage {
    // 匹配 [xxx](http...)，非贪婪
    // final reg = RegExp(r'\[[^\]]*\]\(https?[^\)]*\)', caseSensitive: false);
    // 匹配 (http...)，非贪婪
    final reg = RegExp(r'\(http?[^\)]*\)', caseSensitive: false);
    var result = replaceAll(reg, '');
    // 删除所有空格和换行
    result = result.replaceAll(RegExp(r'[ \n\r\t]+'), '');
    return result;
  }

  /// AI播放消息内容处理 去除所有匹配 [***](http****) 的内容,其他情况保留

  /// 去除所有成对()包裹且内容以fileTypes结尾的内容，其他情况保留
  // String get aiPlayMessage {
  //   final buffer = StringBuffer();
  //   int i = 0;
  //   while (i < length) {
  //     if (this[i] == '(http') {
  //       int next = indexOf(')', i + 1);
  //       if (next != -1) {
  //         i = next + 1;
  //         continue;
  //       }
  //     }
  //     buffer.write(this[i]);
  //     i++;
  //   }
  //   // 去除()字符
  //   String result = buffer.toString().replaceAll('(', '').replaceAll(')', '');
  //   result = result.replaceAll(RegExp(r'[ \n\r\t]+'), '');
  //   // // 用正则去除 <xm_...> ... </xm> 之间的内容（非贪婪匹配）
  //   // final xmReg = RegExp(r'<xm_[^>]*?>[\s\S]*?<\/xm>', caseSensitive: false);
  //   // result = result.replaceAll(xmReg, '');
  //   return result;
  // }

  String get removeSpaces {
    return replaceAll(RegExp(r'[ \n\r\t]+'), '');
  }

  String get removeNewLines {
    // 只移除换行符
    return replaceAll(RegExp(r'[\n\r]+'), '');
  }

  // 将链接中的下划线替换为短横线
  String get replaceUnderscoreInLinks {
    return replaceAllMapped(
      RegExp(r'\[([^\]]+)\]\(([^\)]+)\)', multiLine: true),
      (m) => '[${(m[1] ?? '').replaceAll('_', '-')}](${m[2]})',
    );
  }

  /// 将连续的图片语法（包括普通、有序、无序列表）合并为一条，图片间用|分隔
  String get xmImgsTag {
    final imgReg = RegExp(r'!\[([^\]]*)\]\(([^\)]+)\)');
    final listReg = RegExp(r'^(\s*)([-*]|\d+\.)\s+!\[([^\]]*)\]\(([^\)]+)\)\s*$');

    final lines = split('\n');
    final buffer = StringBuffer();
    int i = 0;
    while (i < lines.length) {
      final altList = <String>[];
      final urlList = <String>[];
      int j = i;
      String? listPrefix;
      // 检查是否为有序/无序列表图片
      while (j < lines.length) {
        final match = listReg.firstMatch(lines[j]);
        if (match != null) {
          altList.add(match.group(3) ?? '');
          urlList.add(match.group(4) ?? '');
          listPrefix ??= match.group(1)!.trim() + match.group(2)!;
          j++;
        } else {
          break;
        }
      }
      if (altList.length > 1) {
        // 列表前缀（如 1. 或 -）只保留一次
        // buffer.write((listPrefix != null ? '$listPrefix ' : ''));
        buffer.write('![${altList.join('|')}](${urlList.join('|')})\n');
        i = j;
      } else if (altList.length == 1) {
        buffer.writeln(lines[i]);
        i++;
      } else {
        // 普通图片或非图片行
        final match = imgReg.firstMatch(lines[i]);
        if (match != null) {
          // 检查后面是否有连续普通图片
          altList.add(match.group(1) ?? '');
          urlList.add(match.group(2) ?? '');
          int k = i + 1;
          while (k < lines.length) {
            final m2 = imgReg.firstMatch(lines[k]);
            if (m2 != null) {
              altList.add(m2.group(1) ?? '');
              urlList.add(m2.group(2) ?? '');
              k++;
            } else {
              break;
            }
          }
          if (altList.length > 1) {
            buffer.write('![${altList.join('|')}](${urlList.join('|')})\n');
            i = k;
          } else {
            buffer.writeln(lines[i]);
            i++;
          }
        } else {
          buffer.writeln(lines[i]);
          i++;
        }
      }
    }
    return buffer.toString();
  }

  /// 预处理图片列表，将单行或多行的图片语法用&lt image-group &gt 包裹，方便后续统一处理
  String get preprocessImageList {
    // 只处理图片扩展名（不含视频）
    const imgExt = r'(png|jpg|jpeg|gif|bmp|webp|svg)';
    // 有序列表图片
    var text = replaceAllMapped(
      RegExp(
        r'((?:^	*\d+\.\s*!\[[^\[\]]*\]\([^\)]+\.' + imgExt + r'\)\s*$\n?)+)',
        multiLine: true,
        caseSensitive: false,
      ),
      (match) => '<span class="img-group">${match[0]}</span>',
    );

    // 普通图片
    text = text.replaceAllMapped(
      RegExp(
        r'((?:^\s*!\[[^\[\]]*\]\([^\)]+\.' + imgExt + r'\)\s*$\n?)+)',
        multiLine: true,
        caseSensitive: false,
      ),
      (match) => '<span class="img-group">${match[0]}</span>',
    );

    // 只去除 <img-group>...</img-group> 内部的换行符
    text = text.replaceAllMapped(RegExp(r'<img-group>([\s\S]*?)<\/img-group>'), (match) {
      final inner = match[1];
      return '<span class="img-group">${inner == null ? '' : inner.replaceAll(RegExp(r"[\n\r]+"), "")}</span>';
    });
    return text;
  }

  // 是否是视频链接
  bool get isVideoUrl => contains(RegExp(r'\.(mp4|mov|avi|wmv|flv|mkv)$', caseSensitive: false));
}

const List<String> fileTypes = [
  "mp3",
  "mp4",
  "mov",
  "avi",
  "wmv",
  "flv",
  "mkv",
  "wav",
  "aac",
  "m4a",
  "ogg",
  "pdf",
  "txt",
  "png",
  "jpg",
  "gif",
  "jpeg",
  "doc",
  "docx",
  "doc",
  "xls",
  "xlsx",
  "ppt",
  "pptx",
];
