! This program is a part of EASIFEM library
! Copyright (C) 2020-2021  Vikas Sharma, Ph.D
!
! This program is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with this program.  If not, see <https: //www.gnu.org/licenses/>
!

MODULE easifemClasses
USE ExceptionHandler_Class
USE FPL_Method
USE Files
USE ElementFactory
!FTL Containers
USE IntList_Class
USE RealList_Class
USE StringList_Class
USE ElementList_Class
USE ElementPointerVector_Class
USE Mesh_Class
! USE MeshConnectivity_Class
USE MeshPointerVector_Class
USE Domain_Class
USE MeshSelection_Class
! USE QuadratureVariables_Class


USE Gmsh_Class
USE mshFormat_Class
USE mshPhysicalNames_Class
USE mshEntity_Class
USE mshNodes_Class
USE mshElements_Class
USE MSH_Class
USE AbstractVector_Class
USE Vector_Class

USE Field
USE FieldFactory

USE AbstractBC_Class
USE DirichletBC_Class

  ! USE vtkType


  ! USE Material_Class
  ! USE stdMaterials
  ! USE ThermCondModel_Class
  ! USE VolHeatCapModel_Class
  ! USE SFCCModel_Class

  ! USE ogpf
END MODULE easifemClasses