#!/bin/bash

# Chemin d'accès aux fichiers générés du modèle du point de vue du Makefile du dossier de conception
model=../animUML/conceptionGenerale/$1
objects=$2
interactions=$3
classes=$4
enumerations=$5
activities=$6

declare -A stateMachinesPerClass
. generateLaTeX.config

figure() {
	local file="$1"
	local caption="$2"
	local label="$3"
	echo '\begin{figure}[H]'
	echo '	\centering'
	echo "	\\includegraphics$args{$file}"
	echo "	\\caption{$caption}"
	echo "	\\label{fig:$label}"
	echo '\end{figure}'
}

args='[scale=.5,max width=\textwidth,max height=.9\textheight]'

(
	echo '% WARNING: automatically generated file that may be overwritten or removed at any time'
	echo
    echo '\section{Conception générale}'
	echo
	echo '\newcommand\macroSuffix{}'
	echo "\\input{${model}-macros}"
	echo
	echo
	echo '\subsection{Architecture candidate}'
	echo
	figure "$model-context" "Architecture candidate" "archiCand"
	echo "Le diagramme de la \\autoref{fig:archiCand} représente l'architecture candidate du système."
    # On génère le fichier de description de l'architecture candidate (s'il n'existe pas)
    touch "../../ebauches/sections/2.ConceptionGenerale/descriptionArchiCand/description_archi_candi.tex"
    # On insère le fichier de description de l'architecture candidate sous le diagramme
    echo "\input{sections/2.ConceptionGenerale/descriptionArchiCand/description_archi_candi.tex}"
	echo
	echo '\subsection{Diagrammes de séquence}'
	echo
	for inter in $interactions ; do
		figure "$model-sequence-$inter" "Diagramme de séquence \\emph{${inter//_/ }}" "inter-$inter"
		echo "Le diagramme de la \\autoref{fig:inter-$inter} représente le diagramme de séquence \\emph{${inter//_/ }}."
        # On génère le fichier de description du diagramme de séquence (s'il n'existe pas)
        touch "../../ebauches/sections/2.ConceptionGenerale/descriptionSeq/description_$inter.tex"
        # On insère le fichier de description du diagramme de séquence sous le diagramme
        echo "\input{sections/2.ConceptionGenerale/descriptionSeq/description_$inter.tex}"
		echo
	done
	echo
	echo '\subsection{Types de données}'
	echo
	figure "$model-datatypes" "Diagramme des types de données" "datatypes"
	echo "Le diagramme de la \\autoref{fig:datatypes} représente les types de données utilisés."
    # A décommenter si besoin de commentaires supplémentaires
    # On génère le fichier de description des littéraux (s'il n'existe pas)
    # touch "../../ebauches/sections/2.ConceptionGenerale/descriptionTypes/description_types.tex"
    # On insère le fichier de description des littéraux sous le diagramme
    # echo "\input{sections/2.ConceptionGenerale/descriptionTypes/description_types.tex}"
	echo "\newline"
	for enum in $enumerations ; do
		echo "L'énumération ${enum} possède les littéraux suivants :"
		echo "\\enum${enum}LiteralDescriptions"
	done
	echo
	echo '\subsection{Classes}'
	echo
	echo '\subsubsection{Vue générale}'
	echo
	figure "$model-classes" "Diagramme de classes" "classes"
	echo "Le diagramme de la \\autoref{fig:classes} représente les classes du système."
	echo
	for class in $classes ; do
		echo "\\subsubsection{La classe $class}"
		echo
		echo "Le diagramme de la \\autoref{fig:class-${class}} représente la classe $class."
		figure "$model-class-$class" "Diagramme de la classe $class" "class-$class"
            # On génère le fichier de description du diagramme de classe (s'il n'existe pas)
        touch "../../ebauches/sections/2.ConceptionGenerale/descriptionClass/description_$class.tex"
        # On insère le fichier de description du diagramme de classe sous le diagramme
        echo "\input{sections/2.ConceptionGenerale/descriptionClass/description_$class.tex}"
		echo
		echo '\paragraph{Attributs}'
		echo "\\class${class}Properties"
		echo '\paragraph{Services offerts}'
		echo "\\class${class}Operations"

		if [ "${stateMachinesPerClass[$class]}" != "" ] ; then
			echo '\paragraph{Description comportementale}'
			for stateMachine in ${stateMachinesPerClass[$class]} ; do
				stateName=${stateMachine#*.}
				if [ "$stateMachine" = "$stateName" ] ; then
					objectName="$stateMachine"
					figure "$model-$stateMachine-SM" "Machine à états de \\emph{${class//_/ }}" "sm-$stateMachine"
					echo "Le diagramme de la \\autoref{fig:sm-$stateMachine} représente la machine à états de \\emph{${class//_/ }}".
    			    # On génère le fichier de description de la MAE parente (s'il n'existe pas)
    			    touch "../../ebauches/sections/2.ConceptionGenerale/descriptionMAE/description_MAE_$stateMachine.tex"
					# On insère le fichier de description de la MAE parente sous le diagramme
					echo "\input{sections/2.ConceptionGenerale/descriptionMAE/description_MAE_$stateMachine.tex}"
				else
					figure "$model-$objectName-$stateMachine-SM" "Sous-état \\emph{${stateName}} de \\emph{${class//_/ }}" "sm-$stateMachine"
					echo "Le diagramme de la \\autoref{fig:sm-$stateMachine} représente le sous-état \\emph{$stateName} de la machine à états de \\emph{${class//_/ }}".
    			    # On génère le fichier de description de la MAE parente (s'il n'existe pas)
    			    touch "../../ebauches/sections/2.ConceptionGenerale/descriptionMAE/description_MAE_$objectName-$stateMachine-SM.tex"
					# On insère le fichier de description de la MAE parente sous le diagramme
					echo "\input{sections/2.ConceptionGenerale/descriptionMAE/description_MAE_$objectName-$stateMachine-SM.tex}"
				fi
			done
		fi
	done
	echo
	# echo '\subsection{Machines à états}'
	# echo
	# for object in $objects ; do
	# 	figure "$model-$object-SM" "Machine à états de \\emph{${object//_/ }}" "obj-$object"
	# 	echo "Le diagramme de la \\autoref{fig:obj-$object} représente la machine à états de \\emph{${object//_/ }}."
    #     # On génère le fichier de description de la MAE (s'il n'existe pas)
    #     touch "../../ebauches/sections/2.ConceptionGenerale/descriptionMAE/description_MAE_$object.tex"
    #     # On insère le fichier de description de la MAE sous le diagramme
    #     echo "\input{sections/2.ConceptionGenerale/descriptionMAE/description_MAE_$object.tex}"
	# 	echo
	# done
	echo "\\subsection{Diagrammes d'activité}"
	echo
	for activity in $activities ; do
		op=${activity#*.}
		op=${op//./::}
		figure "{{$model-activity-$activity}}" "Diagramme d'activité de l'opération \\emph{$op}" "activity-$activity"
		echo "Le diagramme de la \\autoref{fig:activity-$activity} représente le comportement de l'opération \\emph{$op}."
        # On génère le fichier de description du diagramme d'activité (s'il n'existe pas)
        touch "../../ebauches/sections/2.ConceptionGenerale/descriptionActivity/description_activity_$activity.tex"
        # On insère le fichier de description du diagramme d'activité sous le diagramme
        echo "\input{sections/2.ConceptionGenerale/descriptionActivity/description_activity_$activity.tex}"
		echo
	done
) > ../../ebauches/sections/2.ConceptionGenerale/conceptionGenerale.tex
