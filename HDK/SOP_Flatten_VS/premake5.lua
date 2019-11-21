-- premake5.lua
-- Houdiniツールキットのサンプル用のVisualStudioソリューションを生成する

-- １．premake5をダウンロードして、このスクリプトと同じ場所に置く
-- https://premake.github.io/download.html#v5
--
-- ２．Houdiniの場所を指定してコマンドラインからpremake5を実行する
-- premake5 --houdiniLocation="C:\Program Files\Side Effects Software\Houdini 17.5.391" vs2017



---------------------------------------------------------------------
-- プロジェクト名の設定
-- プラグイン名にも使う

pluginBaseName = "SOP_Flatten"


---------------------------------------------------------------------
-- options

newoption{
	trigger = "houdiniLocation",
	value = "PATH",
	description = "Houdini Path"
}

---------------------------------------------------------------------
-- リンクするライブラリの設定

windowsLib = {
	'kernel32.lib',
	'user32.lib',
	'gdi32.lib',
	'winspool.lib',
	'shell32.lib',
	'ole32.lib',
	'oleaut32.lib',
	'uuid.lib',
	'comdlg32.lib',
	'advapi32.lib',
}

--Houdiniのライブラリは全てリンクさせる
houLib = { _OPTIONS[ 'houdiniLocation' ] .. "/custom/houdini/dsolib/**.lib", _OPTIONS[ 'houdiniLocation' ] .. "/custom/houdini/dsolib/**.a" }
houObj = {}


---------------------------------------------------------------------
-- solution
solutionName = pluginBaseName
solution( solutionName )
	configurations { "Debug", "Release" }

	platforms{ "x64" }
	
	---------------------------------------------------------------------
	-- solution
	projectName = pluginBaseName
	project( projectName )
		kind "SharedLib"
		language "C++"

		houIncludePath = "\"" .. _OPTIONS[ 'houdiniLocation' ] .. "/toolkit/include" .. "\""
		houLibPath = "\"" .. _OPTIONS[ 'houdiniLocation' ] .. "/custom/houdini/dsolib" .. "\""
		houSamplePath = _OPTIONS[ 'houdiniLocation' ] .. "/toolkit/samples" 
		
		--コンパイルしたいソースファイルをここに書く
		thisPluginSrcs = {
			--今回はサンプルフォルダのSOP_Flatten.Cのみ
			houSamplePath .. "/SOP/SOP_Flatten.C"
		}
		
		files {
			thisPluginSrcs
		}

		--ヘッダを探す場所をここに書く
		includedirs{
			houIncludePath,
			houSamplePath .. "/SOP/"
		}
			
		links{
			houLib,
			windowsLib,
		}

		linkoptions{
			houObj,
		}


		--setting up output directory for multiple version delpoyment.
		targetdir "%{prj.location}/%{cfg.architecture}/%{cfg.buildcfg}"
		objdir "%{prj.location}/%{cfg.architecture}/%{cfg.buildcfg}/obj"
		
		--target setup
		targetname( pluginBaseName )
		implibextension ".lib"
		targetextension ".dll"

		--configuration specific 
		configuration "windows"


		configuration "Debug"
			defines {
				'WIN32',
				'_WINDOWS',
				'HBOOST_ALL_NO_LIB',
				'QT_DLL',
				'__TBB_NO_IMPLICIT_LINKAGE',
				'__TBBMALLOC_NO_IMPLICIT_LINKAGE',
				'__STDC_LIMIT_MACROS',
				'__STDC_CONSTANT_MACROS',
				'_USE_MATH_DEFINES',
				'_CRT_NONSTDC_NO_DEPRECATE',
				'_CRT_SECURE_NO_DEPRECATE',
				'_SCL_SECURE_NO_WARNINGS',
				'_ITERATOR_DEBUG_LEVEL=2',
				'HOUDINI_USE_STEAM',
				'NOMINMAX',
				'WIN32_LEAN_AND_MEAN',
				'WINVER=0x0502',
				'_WIN32_WINNT=0x0502',
				'UT_ASSERT_LEVEL=0',
				'AMD64',
				'HOUDINI_ALPHABETA=1',
				'ENABLE_UI_THREADS',
				'UT_LIBRARY_TYPE=0',
				'HAS_PYTHON',
				'BT_USE_DOUBLE_PRECISION',
				'SIZEOF_VOID_P=8',
				'FBX_ENABLED=1',
				'OPENCL_ENABLED=1',
				'OPENVDB_ENABLED=1',
				'OPENVDB_USE_BLOSC',
				'SESI_LITTLE_ENDIAN',
				'CXX11_ENABLED=1',
				'QT_NO_KEYWORDS=1',
				'USE_QT5=1',
				'EIGEN_MALLOC_ALREADY_ALIGNED=0',
				'MAKING_DSO',
				'SWAP_BITFIELDS',
				'_ITERATOR_DEBUG_LEVEL=2',
				-- HoudiniのSDKはDLLのエントリポイントをプラグイン名_exportsにするが、コンパイラにはその名前を教えてやる必要がある
				pluginBaseName .. "_exports",
			}
			symbols "On"
			buildoptions{ "/openmp", "/bigobj", "/TP" }

			libdirs{
				houLibPath,
			}

		configuration "Release"
			defines{
				'WIN32',
				'_WINDOWS',
				'NDEBUG',
				'HBOOST_ALL_NO_LIB',
				'QT_DLL',
				'__TBB_NO_IMPLICIT_LINKAGE',
				'__TBBMALLOC_NO_IMPLICIT_LINKAGE',
				'__STDC_LIMIT_MACROS',
				'__STDC_CONSTANT_MACROS',
				'_USE_MATH_DEFINES',
				'_CRT_NONSTDC_NO_DEPRECATE',
				'_CRT_SECURE_NO_DEPRECATE',
				'_SCL_SECURE_NO_WARNINGS',
				'_ITERATOR_DEBUG_LEVEL=0',
				'HOUDINI_USE_STEAM',
				'NOMINMAX',
				'WIN32_LEAN_AND_MEAN',
				'WINVER=0x0502',
				'_WIN32_WINNT=0x0502',
				'UT_ASSERT_LEVEL=0',
				'AMD64',
				'HOUDINI_ALPHABETA=1',
				'ENABLE_UI_THREADS',
				'UT_LIBRARY_TYPE=0',
				'HAS_PYTHON',
				'BT_USE_DOUBLE_PRECISION',
				'SIZEOF_VOID_P=8',
				'FBX_ENABLED=1',
				'OPENCL_ENABLED=1',
				'OPENVDB_ENABLED=1',
				'OPENVDB_USE_BLOSC',
				'SESI_LITTLE_ENDIAN',
				'CXX11_ENABLED=1',
				'QT_NO_KEYWORDS=1',
				'USE_QT5=1',
				'EIGEN_MALLOC_ALREADY_ALIGNED=0',
				'MAKING_DSO',
				'SWAP_BITFIELDS',
				'_ITERATOR_DEBUG_LEVEL=0',
				-- HoudiniのSDKはDLLのエントリポイントをプラグイン名_exportsにするが、コンパイラにはその名前を教えてやる必要がある
			     pluginBaseName .. "_exports",
			}

			optimize "Full"
			buildoptions{ "/openmp", "/bigobj", "/TP" }
			
			libdirs{
				houLibPath,
			}
