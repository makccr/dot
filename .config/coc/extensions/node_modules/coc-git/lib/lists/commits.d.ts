import { BasicList, ListAction, ListContext, ListTask, Neovim } from 'coc.nvim';
import Manager from '../manager';
export default class Commits extends BasicList {
    private manager;
    readonly name = "commits";
    readonly description = "Commits of current project.";
    readonly defaultAction = "show";
    actions: ListAction[];
    private cachedCommits;
    constructor(nvim: Neovim, manager: Manager);
    loadItems(context: ListContext): Promise<ListTask>;
}
