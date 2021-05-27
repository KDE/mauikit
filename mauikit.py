import info
from Package.CMakePackageBase import *


class subinfo(info.infoclass):
    def setTargets(self):
        self.svnTargets['master'] = 'https://invent.kde.org/maui/mauikit-filebrowsing.git'

        for ver in ['1.2.2']:
            self.targets[ver] = 'https://download.kde.org/stable/maui/mauikit/1.2.2/mauikit-%s.tar.xz' % ver
            self.archiveNames[ver] = 'mauikit-%s.tar.gz' % ver
            self.targetInstSrc[ver] = 'mauikit-%s' % ver

        self.description = "Templated convergent controls and multi-platform utilities for Maui applications"
        self.defaultTarget = '1.2.2'

    def setDependencies(self):
        self.runtimeDependencies["virtual/base"] = None
        self.runtimeDependencies["libs/qt5/qtbase"] = None
        self.runtimeDependencies["libs/qt5/qtgraphicaleffects"] = None
        self.runtimeDependencies["libs/qt5/qtquickcontrols2"] = None
        self.buildDependencies["kde/frameworks/extra-cmake-modules"] = None


class Package(CMakePackageBase):
    def __init__(self, **args):
        CMakePackageBase.__init__(self)

