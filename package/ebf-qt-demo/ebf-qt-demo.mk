################################################################################
#
# ebf-qt-demo
#
################################################################################

EBF_QT_DEMO_VERSION = v1.0
EBF_QT_DEMO_SOURCE = ebf_qt_demo_v1.0.tar.bz2
EBF_QT_DEMO_SITE = https://github.com/Embdefire/ebf_linux_qt_demo/releases/download/$(EBF_QT_DEMO_VERSION)

define EBF_QT_DEMO_EXTRACT_CMDS
	tar -jxf $(EBF_QT_DEMO_DL_DIR)/$(EBF_QT_DEMO_SOURCE) -C $(@D)
endef

define EBF_QT_DEMO_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/root
	mkdir -p $(TARGET_DIR)/usr/lib
	mkdir -p $(TARGET_DIR)/usr/share/fonts
	cp -rdf $(@D)/fire-qt-app $(TARGET_DIR)/root/.
	cp -rdf $(@D)/qt $(TARGET_DIR)/usr/lib/.
	cp -rdf $(@D)/SourceHanSans $(TARGET_DIR)/usr/share/fonts/.
endef

$(eval $(generic-package))