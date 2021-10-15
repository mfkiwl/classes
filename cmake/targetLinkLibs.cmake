# Link libs to the project

# 1
FUNCTION(FIND_EASIFEM_DEPENDENCY EXT_PKG_LIST)
  FOREACH(p ${EXT_PKG_LIST})
    FIND_PACKAGE( ${p} REQUIRED )
    IF( ${p}_FOUND )
      MESSAGE(STATUS "FOUND ${p}")
    ELSE()
      MESSAGE(ERROR "NOT FOUND ${p}")
    ENDIF()
  ENDFOREACH()
ENDFUNCTION(FIND_EASIFEM_DEPENDENCY)
# 2
FUNCTION(LINK_EASIFEM_DEPENDENCY EXT_PKG_LIST PROJECT_NAME)
  FOREACH(p ${EXT_PKG_LIST})
    TARGET_LINK_LIBRARIES( ${PROJECT_NAME} PUBLIC ${p}::${p} )
  ENDFOREACH()
ENDFUNCTION(LINK_EASIFEM_DEPENDENCY)
# 3
FUNCTION(FIND_INTER_EASIFEM_CLASS_DEPENDENCY)
  FIND_EASIFEM_DEPENDENCY("easifemBase")
ENDFUNCTION(FIND_INTER_EASIFEM_CLASS_DEPENDENCY)
# 4
FUNCTION(LINK_INTER_EASIFEM_CLASS_DEPENDENCY)
  FIND_INTER_EASIFEM_CLASS_DEPENDENCY()
  LINK_EASIFEM_DEPENDENCY("easifemBase" "${PROJECT_NAME}")
ENDFUNCTION(LINK_INTER_EASIFEM_CLASS_DEPENDENCY)
# 5
FUNCTION(FIND_INTER_EASIFEM_MATERIALS_DEPENDENCY)
  FIND_INTER_EASIFEM_CLASS_DEPENDENCY()
  FIND_EASIFEM_DEPENDENCY("easifemClasses")
ENDFUNCTION(FIND_INTER_EASIFEM_MATERIALS_DEPENDENCY)
# 6
FUNCTION(LINK_INTER_EASIFEM_MATERIALS_DEPENDENCY)
  FIND_INTER_EASIFEM_MATERIALS_DEPENDENCY()
  LINK_EASIFEM_DEPENDENCY("easifemClasses" "${PROJECT_NAME}")
ENDFUNCTION(LINK_INTER_EASIFEM_MATERIALS_DEPENDENCY)
# 7
FUNCTION(FIND_INTER_EASIFEM_KERNELS_DEPENDENCY)
  FIND_INTER_EASIFEM_MATERIALS_DEPENDENCY()
  FIND_EASIFEM_DEPENDENCY("easifemMaterials")
ENDFUNCTION(FIND_INTER_EASIFEM_KERNELS_DEPENDENCY)
# 8
FUNCTION(LINK_INTER_EASIFEM_KERNELS_DEPENDENCY)
  FIND_INTER_EASIFEM_KERNELS_DEPENDENCY()
  LINK_EASIFEM_DEPENDENCY("easifemMaterials" "${PROJECT_NAME}")
ENDFUNCTION(LINK_INTER_EASIFEM_KERNELS_DEPENDENCY)

#...........................................................................
# EXTPKGS BASE
# MAKE REGISTER
LIST(APPEND EXT_PKGS LAPACK95 PENF BeFoR64 FACE StringiFor FPL Sparsekit)
FIND_EASIFEM_DEPENDENCY( "${EXT_PKGS}" )
LINK_EASIFEM_DEPENDENCY( "${EXT_PKGS}" "${PROJECT_NAME}" )

# CLASSES
IF( ${PROJECT_NAME} MATCHES "easifemClasses" )
  LINK_INTER_EASIFEM_CLASS_DEPENDENCY()
ENDIF()

# MATERIALS
IF( ${PROJECT_NAME} MATCHES "easifemMaterials" )
  LINK_INTER_EASIFEM_MATERIALS_DEPENDENCY()
ENDIF()

# KERNELS
IF( ${PROJECT_NAME} MATCHES "easifemKernels" )
  LINK_INTER_EASIFEM_KERNELS_DEPENDENCY()
ENDIF()

# STDarcyBrinkmann
IF( ${PROJECT_NAME} MATCHES "STDarcyBrinkmann" )
  LINK_INTER_EASIFEM_KERNELS_DEPENDENCY()
  FIND_EASIFEM_DEPENDENCY("easifemKernels")
  LINK_EASIFEM_DEPENDENCY("easifemKernels" "${PROJECT_NAME}")
ENDIF()