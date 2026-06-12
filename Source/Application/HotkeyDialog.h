#pragma once

#include <QDialog>
#include <QKeySequence>
#include <QMap>

class QAction;
class QKeySequenceEdit;

class HotkeyDialog : public QDialog
{
    Q_OBJECT
public:
    explicit HotkeyDialog(QList<QAction*> actions, QWidget* parent = nullptr);

    QMap<QAction*, QKeySequence> getNewShortcuts() const;

private:
    QList<QAction*> m_actions;
    QList<QKeySequenceEdit*> m_edits;
};
