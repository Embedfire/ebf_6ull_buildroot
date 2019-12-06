# ebf_6ull_buildroot

## 开发环境

**安装依赖库**

```bash
sudo apt-get install -y which sed make binutils build-essential gcc g++ bash patch gzip bzip2 perl tar cpio python unzip rsync file bc wget g++-multilib
```

## 使用野火开发板配置
```bash
make imx6ull_ebf_pro_defconfig
```

## 自定义配置（可选）
```bash
make menuconfig 
```

## 保存配置
```
 make savedefconfig 
```

## 编译
```
 make
```

## 生成镜像路径
```bash
output/images/
```

## 可选配置内容

- 野火qt-demo (默认选择)

```bash
Location:             
    -> Target packages                                     
    -> Graphic libraries and applications (graphic/text) 
        -> Qt5 (BR2_PACKAGE_QT5 [=y])
            -> ebf-qt-demo
```
> 备注：由于buildroot对gstreamer的支持不完善，多媒体无法播放！

# 清除install状态
```bash
./clear.sh 
```

# 其他注意事项
1. 由于本项目是`buildroot`使用 `arm-linux-gnueabihf-5.3.1` 编译工具链编译的，与单独编译的内核镜像使用的编译器版本不一致，可能会导致某些内核模块无法加载，因此如果有必要的话，将`output/images/`目录下的内核镜像 `zImage` 替换掉原本的内核镜像！同理，设备树亦是如此！



