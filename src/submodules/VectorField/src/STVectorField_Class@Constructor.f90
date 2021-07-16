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

SUBMODULE( STVectorField_Class ) Constructor
USE BaseMethod
IMPLICIT NONE
CONTAINS

!----------------------------------------------------------------------------
!                                                        CheckEssentialParam
!----------------------------------------------------------------------------

MODULE PROCEDURE stvField_checkEssentialParam
  CHARACTER( LEN = * ), PARAMETER :: myName = "stvField_checkEssentialParam"
  IF( .NOT. param%isPresent(key="name") ) THEN
    CALL e%raiseError(modName//'::'//myName// " - "// &
    & 'names should be present in param')
  END IF
  IF( .NOT. param%isPresent(key="spaceCompo") ) THEN
    CALL e%raiseError(modName//'::'//myName// " - "// &
    & 'spaceCompo should be present in param')
  END IF
  IF( .NOT. param%isPresent(key="timeCompo") ) THEN
    CALL e%raiseError(modName//'::'//myName// " - "// &
    & 'timeCompo should be present in param')
  END IF
END PROCEDURE stvField_checkEssentialParam

!----------------------------------------------------------------------------
!                                                                   Initiate
!----------------------------------------------------------------------------

MODULE PROCEDURE stvField_Initiate1
  CHARACTER( LEN = * ), PARAMETER :: myName="stvField_Initiate1"
  INTEGER( I4B ) :: ierr, storageFMT, tNodes( 1 ), timeCompo( 1 ), &
    & spaceCompo( 1 )
  CHARACTER( LEN=: ), ALLOCATABLE :: char_var
  CHARACTER( LEN=1 ) :: names_char( 1 )

  !> main program
  IF( obj%isInitiated ) &
    & CALL e%raiseError(modName//'::'//myName// " - "// &
    & 'STVector field object is already initiated')
  CALL obj%checkEssentialParam(param)
  ALLOCATE( CHARACTER( LEN = param%DataSizeInBytes( key="name" ) ) :: char_var )
  ierr = param%get( key="name", value=char_var )
  obj%name = char_var
  names_char( 1 )(1:1) = char_var( 1:1 )
  ierr = param%get( key="spaceCompo", value=obj%spaceCompo )
  ierr = param%get( key="timeCompo", value=obj%timeCompo )
  IF( param%isPresent(key="fieldType") ) THEN
    ierr = param%get( key="fieldType", value=obj%fieldType )
  ELSE
    obj%fieldType = FIELD_TYPE_NORMAL
  END IF
  spaceCompo = obj%spaceCompo
  timeCompo = obj%timeCompo
  storageFMT = FMT_NODES
  obj%domain => dom
  IF( obj%fieldType .EQ. FIELD_TYPE_CONSTANT ) THEN
    CALL e%raiseError(modName//'::'//myName// " - "// &
      & 'A constant space time vector field is not allowed' )
  ELSE
    tNodes = obj%domain%getTotalNodes()
    obj%tSize = tNodes( 1 ) * obj%spaceCompo * obj%timeCompo
  END IF
  CALL initiate( obj=obj%dof, tNodes=tNodes, names=names_char, &
    & spaceCompo=spaceCompo, timeCompo=timeCompo, storageFMT=storageFMT )
  CALL initiate( obj%realVec, obj%dof )
  obj%isInitiated = .TRUE.
  IF( ALLOCATED( char_var ) ) DEALLOCATE( char_var )
END PROCEDURE stvField_Initiate1

!----------------------------------------------------------------------------
!                                                                  Initiate
!----------------------------------------------------------------------------

MODULE PROCEDURE stvField_Initiate2
  CHARACTER( LEN = * ), PARAMETER :: myName="stvField_Initiate2"
  CALL e%raiseError(modName//'::'//myName// " - "// &
    & 'This method has not been implemented so far')
END PROCEDURE stvField_Initiate2

!----------------------------------------------------------------------------
!                                                             DeallocateData
!----------------------------------------------------------------------------

MODULE PROCEDURE stvField_DeallocateData
  CHARACTER( LEN = * ), PARAMETER :: myName="stvField_DeallocateData"
  obj%tSize = 0_I4B
  obj%name = ''
  obj%spaceCompo = 0_I4B
  obj%timeCompo = 0_I4B
  obj%isInitiated = .FALSE.
  obj%fieldType = FIELD_TYPE_CONSTANT
  CALL DeallocateData( obj%realvec )
  CALL DeallocateData( obj%dof )
  NULLIFY( obj%domain )
END PROCEDURE stvField_DeallocateData

!----------------------------------------------------------------------------
!                                                                     Final
!----------------------------------------------------------------------------

MODULE PROCEDURE stvField_Final
  CALL obj%DeallocateData()
END PROCEDURE stvField_Final

!----------------------------------------------------------------------------
!                                                                STVectorField
!----------------------------------------------------------------------------

MODULE PROCEDURE stvField_Constructor1
  CALL ans%initiate( param, dom )
END PROCEDURE stvField_Constructor1

!----------------------------------------------------------------------------
!                                                        STVectorField_Pointer
!----------------------------------------------------------------------------

MODULE PROCEDURE stvField_Constructor_1
  ALLOCATE( ans )
  CALL ans%initiate( param, dom )
END PROCEDURE stvField_Constructor_1

!----------------------------------------------------------------------------
!
!----------------------------------------------------------------------------

END SUBMODULE Constructor